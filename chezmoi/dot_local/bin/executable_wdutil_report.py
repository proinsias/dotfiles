#!/usr/bin/env python3
"""
wdutil_report.py

Parses a wdutil wifi.log file and produces a self-contained HTML diagnostic
report, covering:

    - Connection timeline (associations, disassociations, roam events)
    - Signal quality samples (RSSI, noise, SNR, MCS index, Tx rate)
    - Channel changes
    - Error and warning events
    - Summary statistics (uptime, drop count, roam count, avg RSSI)

Log line format emitted by wdutil log +wifi:
    Day Mon DD HH:MM:SS.mmm Category: <source[pid]> message text
    e.g.:
    Tue Dec 15 13:21:12.857 Driver Event: <airport[175]> _bsd_80211_event_callback: APPLE80211_M_ROAM_START (en0)
    Tue Dec 15 13:21:16.649 Info: <airport[175]> Roaming ended on interface en0
    Mon May 12 08:14:03.221 <kernel> RSSI: -58 Noise: -92 MCS: 7 TxRate: 540.0

Usage:
    python3 wdutil_report.py --log /path/to/wifi.log --out report.html [--year 2025]

Dependencies: stdlib only (no third-party packages required).
"""

from __future__ import annotations

import argparse
import html
import json
import re
import sys
from dataclasses import dataclass, field
from datetime import datetime
from pathlib import Path
from typing import Optional


# ---------------------------------------------------------------------------
# Data models
# ---------------------------------------------------------------------------

@dataclass
class LogEvent:
    """A single parsed event extracted from a wdutil log line."""
    timestamp: datetime
    category: str          # e.g. "Driver Event", "Info", "kernel"
    source: str            # e.g. "airport[175]", "kernel"
    message: str           # raw message text after the source tag
    event_type: str        # classified type (see EVENT_TYPE_* constants)
    detail: dict           # structured fields extracted from the message


# Event type constants
ET_ROAM_START       = "roam_start"
ET_ROAM_END         = "roam_end"
ET_ASSOCIATE        = "associate"
ET_DISASSOCIATE     = "disassociate"
ET_SIGNAL           = "signal"
ET_CHANNEL_CHANGE   = "channel_change"
ET_AUTH             = "auth"
ET_ERROR            = "error"
ET_WARNING          = "warning"
ET_OTHER            = "other"


# ---------------------------------------------------------------------------
# Regex patterns for log line structure and event content
# ---------------------------------------------------------------------------

# Top-level line structure:
#   Day Mon DD HH:MM:SS.mmm  Category:  <source[pid]>  message
#   OR for kernel lines:
#   Day Mon DD HH:MM:SS.mmm  <kernel>  message
_RE_LINE = re.compile(
    r'^(?P<dow>\w{3})\s+'
    r'(?P<mon>\w{3})\s+'
    r'(?P<day>\d{1,2})\s+'
    r'(?P<time>\d{2}:\d{2}:\d{2}\.\d+)\s+'
    r'(?:(?P<category>[^:<>]+?):\s+)?'   # optional "Category: "
    r'<(?P<source>[^>]+)>\s+'
    r'(?P<message>.+)$'
)

# Signal metrics — appear in kernel lines or Info lines
_RE_RSSI    = re.compile(r'RSSI[:\s]+(-?\d+)')
_RE_NOISE   = re.compile(r'Noise[:\s]+(-?\d+)')
_RE_MCS     = re.compile(r'MCS(?:\s+Index)?[:\s]+(\d+)')
_RE_TXRATE  = re.compile(r'Tx\s*Rate[:\s]+([\d.]+)')

# Channel change
_RE_CHANNEL = re.compile(r'[Cc]hannel[:\s]+(\S+)')

# BSSID in roam metric lines
_RE_BSSID   = re.compile(r'target:\{[^}]+\}\s*\((-?\d+)\)')

# Association
_RE_SSID    = re.compile(r"associated\s+(?:to|with)\s+'?([^'\"]+)'?", re.IGNORECASE)


# ---------------------------------------------------------------------------
# Month mapping for datetime parsing (wdutil uses abbreviated month names)
# ---------------------------------------------------------------------------
_MONTHS = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
    'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
    'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
}


def _parse_timestamp(mon: str, day: str, time_str: str, year: int) -> datetime:
    """
    Parse a wdutil timestamp into a datetime.

    wdutil does not include the year in log lines, so we accept it as a
    parameter. The fractional seconds component may vary in precision.

    Args:
        mon:      Three-letter month abbreviation, e.g. "Dec".
        day:      Day-of-month string, e.g. "15".
        time_str: Time string, e.g. "13:21:12.857".
        year:     Calendar year to assume for all log lines.

    Returns:
        A datetime object (microsecond precision).

    >>> _parse_timestamp("Dec", "15", "13:21:12.857", 2024).month
    12
    >>> _parse_timestamp("Jan", "1", "00:00:00.000", 2025).year
    2025
    """
    month = _MONTHS.get(mon, 1)
    day_i = int(day)
    h, m, rest = time_str.split(':')
    sec_parts = rest.split('.')
    sec = int(sec_parts[0])
    # Normalise fractional seconds to microseconds (wdutil uses milliseconds)
    frac = sec_parts[1] if len(sec_parts) > 1 else '0'
    usec = int(frac.ljust(6, '0')[:6])
    return datetime(year, month, day_i, int(h), int(m), sec, usec)


def _extract_signal_fields(message: str) -> dict:
    """
    Extract RSSI, Noise, MCS, and TxRate from a message string.

    Returns a dict with keys 'rssi', 'noise', 'snr', 'mcs', 'txrate',
    each None if not found. SNR is derived as rssi - noise when both
    values are present.

    >>> fields = _extract_signal_fields("RSSI: -58 Noise: -92 MCS: 7 TxRate: 540.0")
    >>> fields['rssi']
    -58
    >>> fields['snr']
    34
    """
    rssi  = int(m.group(1)) if (m := _RE_RSSI.search(message)) else None
    noise = int(m.group(1)) if (m := _RE_NOISE.search(message)) else None
    mcs   = int(m.group(1)) if (m := _RE_MCS.search(message)) else None
    txrate = float(m.group(1)) if (m := _RE_TXRATE.search(message)) else None
    snr   = (rssi - noise) if (rssi is not None and noise is not None) else None
    return {'rssi': rssi, 'noise': noise, 'snr': snr, 'mcs': mcs, 'txrate': txrate}


def _classify_event(category: str, message: str) -> tuple[str, dict]:
    """
    Classify a log line into an event type and extract structured detail.

    Args:
        category: The log category string (e.g. "Driver Event", "Info").
        message:  The raw message content after the source tag.

    Returns:
        A (event_type, detail) tuple.
    """
    msg_lower = message.lower()
    detail: dict = {}

    # Roam events
    if 'APPLE80211_M_ROAM_START' in message or 'Roaming started' in message:
        return ET_ROAM_START, detail

    if 'Roaming ended' in message or 'RSN_HANDSHAKE_DONE' in message:
        # Try to extract roam latency if present
        if m := re.search(r'latency:([\d.]+)s', message):
            detail['latency_s'] = float(m.group(1))
        if m := _RE_BSSID.search(message):
            detail['target_rssi'] = int(m.group(1))
        return ET_ROAM_END, detail

    # Association / disassociation
    if 'APPLE80211_M_SSID_CHANGED' in message or re.search(r'associated\s+to', message, re.I):
        if m := _RE_SSID.search(message):
            detail['ssid'] = m.group(1).strip()
        return ET_ASSOCIATE, detail

    if any(kw in msg_lower for kw in (
        'disassociat', 'deauthenticate', 'link down',
        'apple80211_m_link_changed'
    )):
        return ET_DISASSOCIATE, detail

    # Channel change
    if 'channel' in msg_lower and any(kw in msg_lower for kw in ('changed', 'switch', 'updated')):
        if m := _RE_CHANNEL.search(message):
            detail['channel'] = m.group(1)
        return ET_CHANNEL_CHANGE, detail

    # Signal metrics (kernel lines usually)
    sig = _extract_signal_fields(message)
    if sig['rssi'] is not None:
        detail.update(sig)
        return ET_SIGNAL, detail

    # Auth / EAPOL
    if any(kw in msg_lower for kw in ('eapol', 'handshake', 'gtk', 'ptk', 'pmk')):
        return ET_AUTH, detail

    # Errors
    if any(kw in msg_lower for kw in ('error', 'fail', 'timeout', 'unreachable')):
        return ET_ERROR, detail

    # Warnings
    if any(kw in msg_lower for kw in ('warn', 'retry', 'lost', 'drop')):
        return ET_WARNING, detail

    return ET_OTHER, detail


# ---------------------------------------------------------------------------
# Parser
# ---------------------------------------------------------------------------

def parse_log(log_path: Path, year: int) -> list[LogEvent]:
    """
    Parse a wdutil wifi.log file into a list of LogEvent objects.

    Lines that do not match the expected format are silently skipped —
    wdutil occasionally emits continuation lines or separator lines.

    Args:
        log_path: Path to the wifi.log file.
        year:     Calendar year to assign to all timestamps.

    Returns:
        A chronologically ordered list of LogEvent objects.

    Raises:
        FileNotFoundError: If log_path does not exist.
        PermissionError:   If the file is not readable.
    """
    events: list[LogEvent] = []
    skipped = 0

    with log_path.open('r', encoding='utf-8', errors='replace') as fh:
        for lineno, raw_line in enumerate(fh, start=1):
            line = raw_line.strip()
            if not line:
                continue

            m = _RE_LINE.match(line)
            if not m:
                skipped += 1
                continue

            try:
                ts = _parse_timestamp(
                    m.group('mon'),
                    m.group('day'),
                    m.group('time'),
                    year,
                )
            except (ValueError, KeyError):
                skipped += 1
                continue

            category = (m.group('category') or '').strip()
            source   = m.group('source').strip()
            message  = m.group('message').strip()

            event_type, detail = _classify_event(category, message)

            events.append(LogEvent(
                timestamp  = ts,
                category   = category,
                source     = source,
                message    = message,
                event_type = event_type,
                detail     = detail,
            ))

    if skipped:
        print(f"[wdutil_report] Skipped {skipped} unparseable lines.", file=sys.stderr)

    return events


# ---------------------------------------------------------------------------
# Statistics aggregation
# ---------------------------------------------------------------------------

@dataclass
class ReportStats:
    """Aggregated statistics derived from the parsed event list."""
    total_events:    int = 0
    roam_count:      int = 0
    drop_count:      int = 0       # disassociation events
    error_count:     int = 0
    warning_count:   int = 0
    signal_samples:  list[dict] = field(default_factory=list)
    timeline:        list[dict] = field(default_factory=list)
    channel_changes: list[dict] = field(default_factory=list)
    log_start:       Optional[datetime] = None
    log_end:         Optional[datetime] = None

    @property
    def duration_hours(self) -> Optional[float]:
        """Total log duration in hours, or None if fewer than two events."""
        if self.log_start and self.log_end:
            delta = (self.log_end - self.log_start).total_seconds()
            return round(delta / 3600, 2)
        return None

    @property
    def avg_rssi(self) -> Optional[float]:
        """Mean RSSI across all signal samples, or None if no samples."""
        values = [s['rssi'] for s in self.signal_samples if s.get('rssi') is not None]
        return round(sum(values) / len(values), 1) if values else None

    @property
    def avg_snr(self) -> Optional[float]:
        """Mean SNR across all signal samples, or None if no samples."""
        values = [s['snr'] for s in self.signal_samples if s.get('snr') is not None]
        return round(sum(values) / len(values), 1) if values else None

    @property
    def min_rssi(self) -> Optional[int]:
        """Minimum (weakest) RSSI observed."""
        values = [s['rssi'] for s in self.signal_samples if s.get('rssi') is not None]
        return min(values) if values else None

    @property
    def max_rssi(self) -> Optional[int]:
        """Maximum (strongest) RSSI observed."""
        values = [s['rssi'] for s in self.signal_samples if s.get('rssi') is not None]
        return max(values) if values else None


def aggregate(events: list[LogEvent]) -> ReportStats:
    """
    Compute summary statistics and build structured lists for the HTML report.

    Args:
        events: Parsed log events in chronological order.

    Returns:
        A populated ReportStats instance.
    """
    stats = ReportStats(total_events=len(events))

    if not events:
        return stats

    stats.log_start = events[0].timestamp
    stats.log_end   = events[-1].timestamp

    # Timeline: only events meaningful for display
    _TIMELINE_TYPES = {
        ET_ROAM_START, ET_ROAM_END, ET_ASSOCIATE,
        ET_DISASSOCIATE, ET_ERROR, ET_WARNING, ET_CHANNEL_CHANGE,
    }

    for ev in events:
        ts_str = ev.timestamp.strftime('%Y-%m-%d %H:%M:%S')

        if ev.event_type == ET_ROAM_START:
            stats.roam_count += 1
            stats.timeline.append({'ts': ts_str, 'type': ev.event_type, 'msg': 'Roam started'})

        elif ev.event_type == ET_ROAM_END:
            latency = ev.detail.get('latency_s')
            msg = f"Roam ended" + (f" (latency {latency:.2f}s)" if latency else "")
            stats.timeline.append({'ts': ts_str, 'type': ev.event_type, 'msg': msg})

        elif ev.event_type == ET_ASSOCIATE:
            ssid = ev.detail.get('ssid', '')
            msg  = f"Associated" + (f" to '{ssid}'" if ssid else "")
            stats.timeline.append({'ts': ts_str, 'type': ev.event_type, 'msg': msg})

        elif ev.event_type == ET_DISASSOCIATE:
            stats.drop_count += 1
            stats.timeline.append({'ts': ts_str, 'type': ev.event_type, 'msg': 'Disassociated'})

        elif ev.event_type == ET_ERROR:
            stats.error_count += 1
            stats.timeline.append({
                'ts': ts_str, 'type': ev.event_type,
                'msg': ev.message[:120],
            })

        elif ev.event_type == ET_WARNING:
            stats.warning_count += 1
            stats.timeline.append({
                'ts': ts_str, 'type': ev.event_type,
                'msg': ev.message[:120],
            })

        elif ev.event_type == ET_CHANNEL_CHANGE:
            ch = ev.detail.get('channel', '?')
            stats.channel_changes.append({'ts': ts_str, 'channel': ch})
            stats.timeline.append({
                'ts': ts_str, 'type': ev.event_type,
                'msg': f"Channel changed to {ch}",
            })

        elif ev.event_type == ET_SIGNAL:
            stats.signal_samples.append({
                'ts':     ts_str,
                'rssi':   ev.detail.get('rssi'),
                'noise':  ev.detail.get('noise'),
                'snr':    ev.detail.get('snr'),
                'mcs':    ev.detail.get('mcs'),
                'txrate': ev.detail.get('txrate'),
            })

    return stats


# ---------------------------------------------------------------------------
# HTML generation
# ---------------------------------------------------------------------------

def _rssi_class(rssi: Optional[int]) -> str:
    """Return a CSS quality class based on RSSI value (dBm)."""
    if rssi is None:
        return 'q-unknown'
    if rssi >= -60:
        return 'q-good'
    if rssi >= -75:
        return 'q-fair'
    return 'q-poor'


def _snr_label(snr: Optional[float]) -> str:
    """Human-readable quality label from SNR (dB)."""
    if snr is None:
        return '—'
    if snr >= 25:
        return f"{snr:.0f} dB ✓ Excellent"
    if snr >= 15:
        return f"{snr:.0f} dB ~ Fair"
    return f"{snr:.0f} dB ✗ Poor"


_EVENT_ICONS = {
    ET_ROAM_START:    ('🔀', 'ev-roam'),
    ET_ROAM_END:      ('✅', 'ev-roam-end'),
    ET_ASSOCIATE:     ('🔗', 'ev-assoc'),
    ET_DISASSOCIATE:  ('💥', 'ev-drop'),
    ET_ERROR:         ('🚨', 'ev-error'),
    ET_WARNING:       ('⚠️',  'ev-warn'),
    ET_CHANNEL_CHANGE:('📡', 'ev-channel'),
    ET_OTHER:         ('·',  'ev-other'),
}


def generate_html(stats: ReportStats, log_path: Path) -> str:
    """
    Render a self-contained HTML report from aggregated statistics.

    Embeds all CSS and the signal data as an inline JSON block consumed by
    a small vanilla-JS chart. No external network requests are made.

    Args:
        stats:    Aggregated ReportStats.
        log_path: Original log path (used only for display in the header).

    Returns:
        A UTF-8 HTML string.
    """

    def _fmt(val: object, suffix: str = '') -> str:
        """Format a value for display, substituting em-dash for None."""
        return f"{val}{suffix}" if val is not None else '—'

    # Inline signal data for the chart (subsample to ≤300 points)
    samples = stats.signal_samples
    step = max(1, len(samples) // 300)
    chart_data = json.dumps([
        {'t': s['ts'], 'r': s['rssi'], 'n': s['noise'], 'snr': s['snr']}
        for s in samples[::step]
        if s.get('rssi') is not None
    ])

    # Timeline rows
    timeline_rows = ''
    for ev in stats.timeline[-500:]:    # cap at 500 for page size
        icon, css_cls = _EVENT_ICONS.get(ev['type'], ('·', 'ev-other'))
        timeline_rows += (
            f'<tr class="{css_cls}">'
            f'<td class="ts">{html.escape(ev["ts"])}</td>'
            f'<td class="ev-icon">{icon}</td>'
            f'<td>{html.escape(ev["msg"])}</td>'
            f'</tr>\n'
        )

    # Signal table rows (last 50 samples)
    signal_rows = ''
    for s in samples[-50:]:
        qcls = _rssi_class(s.get('rssi'))
        signal_rows += (
            f'<tr class="{qcls}">'
            f'<td class="ts">{html.escape(s["ts"])}</td>'
            f'<td>{_fmt(s.get("rssi"), " dBm")}</td>'
            f'<td>{_fmt(s.get("noise"), " dBm")}</td>'
            f'<td>{_fmt(s.get("snr"), " dB")}</td>'
            f'<td>{_fmt(s.get("mcs"))}</td>'
            f'<td>{_fmt(s.get("txrate"), " Mbps")}</td>'
            f'</tr>\n'
        )

    generated_at = datetime.now().strftime('%Y-%m-%d %H:%M:%S')

    no_events_row = (
        '<tr><td colspan="3" style="color:var(--muted);padding:16px">'
        'No significant events found.</td></tr>'
    )
    no_signal_row = (
        '<tr><td colspan="6" style="color:var(--muted);padding:16px">'
        'No signal samples found.</td></tr>'
    )

    return f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>WiFi Diagnostic Report</title>
<style>
    :root {{
        --bg:        #0d1117;
        --surface:   #161b22;
        --border:    #30363d;
        --accent:    #58a6ff;
        --good:      #3fb950;
        --fair:      #d29922;
        --poor:      #f85149;
        --muted:     #8b949e;
        --text:      #c9d1d9;
        --heading:   #e6edf3;
        --mono:      ui-monospace, 'Cascadia Code', 'SF Mono', Consolas, monospace;
        --sans:      system-ui, -apple-system, 'Segoe UI', sans-serif;
    }}

    * {{ box-sizing: border-box; margin: 0; padding: 0; }}

    body {{
        background: var(--bg);
        color: var(--text);
        font-family: var(--sans);
        font-size: 14px;
        line-height: 1.6;
    }}

    header {{
        background: var(--surface);
        border-bottom: 1px solid var(--border);
        padding: 24px 32px;
        display: flex;
        align-items: baseline;
        gap: 16px;
        flex-wrap: wrap;
    }}
    header h1 {{
        font-family: var(--mono);
        font-size: 1.3rem;
        color: var(--accent);
        letter-spacing: -0.5px;
    }}
    header .meta {{
        font-size: 12px;
        color: var(--muted);
        font-family: var(--mono);
    }}

    main {{ padding: 24px 32px; max-width: 1400px; margin: 0 auto; }}

    /* ---- stat cards ---- */
    .cards {{
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
        gap: 12px;
        margin-bottom: 32px;
    }}
    .card {{
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 16px;
    }}
    .card .label {{
        font-size: 11px;
        text-transform: uppercase;
        letter-spacing: 0.8px;
        color: var(--muted);
        margin-bottom: 6px;
    }}
    .card .value {{
        font-family: var(--mono);
        font-size: 1.5rem;
        font-weight: 600;
        color: var(--heading);
    }}
    .card.alert .value {{ color: var(--poor); }}
    .card.warn  .value {{ color: var(--fair); }}
    .card.good  .value {{ color: var(--good); }}

    /* ---- section ---- */
    section {{
        margin-bottom: 36px;
    }}
    section h2 {{
        font-family: var(--mono);
        font-size: 0.85rem;
        text-transform: uppercase;
        letter-spacing: 1px;
        color: var(--muted);
        border-bottom: 1px solid var(--border);
        padding-bottom: 8px;
        margin-bottom: 14px;
    }}

    /* ---- chart ---- */
    #chart-wrap {{
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 6px;
        padding: 16px;
        position: relative;
        height: 220px;
    }}
    canvas#sigchart {{ width: 100% !important; height: 100% !important; }}

    /* ---- tables ---- */
    .tbl-wrap {{
        overflow-x: auto;
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 6px;
    }}
    table {{
        width: 100%;
        border-collapse: collapse;
        font-family: var(--mono);
        font-size: 12px;
    }}
    th {{
        background: var(--bg);
        color: var(--muted);
        text-align: left;
        padding: 8px 12px;
        font-weight: 600;
        font-size: 11px;
        letter-spacing: 0.5px;
        border-bottom: 1px solid var(--border);
        white-space: nowrap;
    }}
    td {{
        padding: 6px 12px;
        border-bottom: 1px solid #21262d;
        vertical-align: top;
    }}
    tr:last-child td {{ border-bottom: none; }}

    .ts {{ color: var(--muted); white-space: nowrap; }}
    .ev-icon {{ text-align: center; width: 32px; }}

    /* timeline row colours */
    .ev-drop td   {{ color: var(--poor); }}
    .ev-error td  {{ color: var(--poor); }}
    .ev-warn td   {{ color: var(--fair); }}
    .ev-roam td   {{ color: #a5d6ff; }}
    .ev-roam-end td {{ color: var(--good); }}
    .ev-assoc td  {{ color: var(--good); }}
    .ev-channel td {{ color: #d2a8ff; }}

    /* signal quality row colours */
    .q-good td  {{ color: var(--good); }}
    .q-fair td  {{ color: var(--fair); }}
    .q-poor td  {{ color: var(--poor); }}
    tr.q-good td.ts,
    tr.q-fair td.ts,
    tr.q-poor td.ts {{ color: var(--muted); }}

    footer {{
        text-align: center;
        padding: 24px;
        font-size: 11px;
        font-family: var(--mono);
        color: var(--muted);
        border-top: 1px solid var(--border);
        margin-top: 8px;
    }}
</style>
</head>
<body>

<header>
    <h1>📶 WiFi Diagnostic Report</h1>
    <span class="meta">
        {html.escape(str(log_path))} &nbsp;|&nbsp; generated {generated_at}
    </span>
</header>

<main>

    <!-- Summary cards -->
    <div class="cards">
        <div class="card">
            <div class="label">Log Duration</div>
            <div class="value">{_fmt(stats.duration_hours, 'h')}</div>
        </div>
        <div class="card {'alert' if stats.drop_count > 5 else 'warn' if stats.drop_count > 0 else 'good'}">
            <div class="label">Disconnections</div>
            <div class="value">{stats.drop_count}</div>
        </div>
        <div class="card {'warn' if stats.roam_count > 10 else ''}">
            <div class="label">Roam Events</div>
            <div class="value">{stats.roam_count}</div>
        </div>
        <div class="card {'alert' if stats.error_count > 0 else ''}">
            <div class="label">Errors</div>
            <div class="value">{stats.error_count}</div>
        </div>
        <div class="card {'warn' if stats.warning_count > 0 else ''}">
            <div class="label">Warnings</div>
            <div class="value">{stats.warning_count}</div>
        </div>
        <div class="card {_rssi_class(int(stats.avg_rssi)) if stats.avg_rssi else ''}">
            <div class="label">Avg RSSI</div>
            <div class="value">{_fmt(stats.avg_rssi, ' dBm')}</div>
        </div>
        <div class="card">
            <div class="label">RSSI Range</div>
            <div class="value" style="font-size:1rem">{_fmt(stats.min_rssi)} / {_fmt(stats.max_rssi)}</div>
        </div>
        <div class="card">
            <div class="label">Avg SNR</div>
            <div class="value">{_fmt(stats.avg_snr, ' dB')}</div>
        </div>
        <div class="card">
            <div class="label">Signal Samples</div>
            <div class="value">{len(stats.signal_samples)}</div>
        </div>
    </div>

    <!-- Signal chart -->
    <section>
        <h2>Signal Quality Over Time</h2>
        <div id="chart-wrap">
            <canvas id="sigchart"></canvas>
        </div>
    </section>

    <!-- Connection timeline -->
    <section>
        <h2>Connection Timeline</h2>
        <div class="tbl-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Timestamp</th>
                        <th></th>
                        <th>Event</th>
                    </tr>
                </thead>
                <tbody>
                    {timeline_rows or no_events_row}
                </tbody>
            </table>
        </div>
    </section>

    <!-- Signal samples -->
    <section>
        <h2>Recent Signal Samples (last 50)</h2>
        <div class="tbl-wrap">
            <table>
                <thead>
                    <tr>
                        <th>Timestamp</th>
                        <th>RSSI</th>
                        <th>Noise</th>
                        <th>SNR</th>
                        <th>MCS</th>
                        <th>Tx Rate</th>
                    </tr>
                </thead>
                <tbody>
                    {signal_rows or no_signal_row}
                </tbody>
            </table>
        </div>
    </section>

</main>

<footer>wdutil_report.py &mdash; WiFi diagnostic parser &mdash; {generated_at}</footer>

<script>
// Minimal canvas chart — no external dependencies
(function() {{
    const raw = {chart_data};
    if (!raw.length) return;

    const canvas = document.getElementById('sigchart');
    const ctx    = canvas.getContext('2d');
    const wrap   = document.getElementById('chart-wrap');

    function resize() {{
        canvas.width  = wrap.clientWidth  - 32;
        canvas.height = wrap.clientHeight - 32;
        draw();
    }}

    function draw() {{
        const W = canvas.width, H = canvas.height;
        ctx.clearRect(0, 0, W, H);

        // Value range
        const rssiVals = raw.map(d => d.r).filter(v => v != null);
        const minV = Math.min(-100, ...rssiVals) - 5;
        const maxV = Math.max(-30,  ...rssiVals) + 5;

        const toY = v => H - ((v - minV) / (maxV - minV)) * H;
        const toX = i => (i / (raw.length - 1 || 1)) * W;

        // Grid lines at -50, -60, -70, -80, -90
        ctx.setLineDash([3, 4]);
        ctx.lineWidth = 1;
        [-50, -60, -70, -80, -90].forEach(v => {{
            const y = toY(v);
            ctx.strokeStyle = v >= -60 ? '#3fb95033' : v <= -75 ? '#f8514933' : '#30363d';
            ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(W, y); ctx.stroke();
            ctx.fillStyle = '#8b949e';
            ctx.font = '10px ui-monospace, Consolas, monospace';
            ctx.fillText(v + ' dBm', 4, y - 3);
        }});
        ctx.setLineDash([]);

        // Noise line (faint)
        const noiseVals = raw.filter(d => d.n != null);
        if (noiseVals.length > 1) {{
            ctx.beginPath();
            ctx.strokeStyle = '#8b949e55';
            ctx.lineWidth = 1;
            noiseVals.forEach((d, i) => {{
                const xi = raw.indexOf(d);
                const x  = toX(xi), y = toY(d.n);
                i === 0 ? ctx.moveTo(x, y) : ctx.lineTo(x, y);
            }});
            ctx.stroke();
        }}

        // RSSI line with colour gradient per quality
        ctx.lineWidth = 2;
        for (let i = 1; i < raw.length; i++) {{
            const prev = raw[i-1], curr = raw[i];
            if (prev.r == null || curr.r == null) continue;
            const colour = curr.r >= -60 ? '#3fb950' : curr.r >= -75 ? '#d29922' : '#f85149';
            ctx.strokeStyle = colour;
            ctx.beginPath();
            ctx.moveTo(toX(i-1), toY(prev.r));
            ctx.lineTo(toX(i),   toY(curr.r));
            ctx.stroke();
        }}

        // Legend
        ctx.font = '11px ui-monospace, Consolas, monospace';
        [['RSSI', '#58a6ff', 20], ['Noise', '#8b949e', 90]].forEach(([label, col, x]) => {{
            ctx.fillStyle = col;
            ctx.fillRect(x, 8, 16, 3);
            ctx.fillStyle = '#8b949e';
            ctx.fillText(label, x + 20, 14);
        }});
    }}

    window.addEventListener('resize', resize);
    resize();
}})();
</script>
</body>
</html>"""


# ---------------------------------------------------------------------------
# CLI entrypoint
# ---------------------------------------------------------------------------

def main() -> None:
    """Parse arguments, run the pipeline, and write the HTML report."""
    parser = argparse.ArgumentParser(
        description='Parse a wdutil wifi.log file and generate an HTML diagnostic report.',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=__doc__,
    )
    parser.add_argument(
        '--log', required=True, type=Path,
        help='Path to the wdutil wifi.log file (or the captured copy on Desktop).',
    )
    parser.add_argument(
        '--out', required=True, type=Path,
        help='Output path for the HTML report, e.g. ~/Desktop/wifi_report.html',
    )
    parser.add_argument(
        '--year', type=int, default=datetime.now().year,
        help='Calendar year to assign to log timestamps (default: current year).',
    )
    args = parser.parse_args()

    if not args.log.exists():
        print(f"ERROR: Log file not found: {args.log}", file=sys.stderr)
        sys.exit(1)

    print(f"[wdutil_report] Parsing {args.log} …")
    events = parse_log(args.log, args.year)
    print(f"[wdutil_report] {len(events)} events parsed.")

    stats = aggregate(events)
    print(
        f"[wdutil_report] Duration: {stats.duration_hours}h | "
        f"Drops: {stats.drop_count} | Roams: {stats.roam_count} | "
        f"Avg RSSI: {stats.avg_rssi} dBm"
    )

    html_str = generate_html(stats, args.log)
    args.out.write_text(html_str, encoding='utf-8')
    print(f"[wdutil_report] Report written to {args.out}")


if __name__ == '__main__':
    main()
