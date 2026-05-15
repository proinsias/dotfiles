#!/usr/bin/env bash
# =============================================================================
# wifi_log_manager.sh
#
# Manages a persistent `wdutil log +wifi` session and incrementally copies
# new log data from /tmp/wifi.log to a destination file on your Desktop.
#
# Designed to be run periodically via cron, e.g. every 15 minutes:
#   */15 * * * * /path/to/wifi_log_manager.sh
#
# Uses `flock` (Homebrew util-linux) to guarantee only one instance of this
# script runs at a time, and a separate pidfile to track the long-running
# `wdutil log` background process.
#
# Must run as root — wdutil requires elevated privileges.
#
# Files managed:
#   LOCKFILE  : /var/run/wifi_log_manager.lock  — flock exclusive lock
#   PIDFILE   : /var/run/wifi_log_manager.pid   — PID of the wdutil process
#   OFFSETFILE: /var/run/wifi_log_manager.offset — byte offset already copied
#   SOURCE    : /tmp/wifi.log                   — written by wdutil
#   DEST      : ~/Desktop/wifi_capture.log      — your persistent output
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
readonly SOURCE="/tmp/wifi.log"
readonly DEST="${HOME}/Desktop/wifi_capture.log"
readonly LOCKFILE="/var/run/wifi_log_manager.lock"
readonly PIDFILE="/var/run/wifi_log_manager.pid"
readonly OFFSETFILE="/var/run/wifi_log_manager.offset"
readonly LOG_TAG="wifi_log_manager"

# Resolve flock from Homebrew — adjust if your prefix differs
# Apple Silicon: /opt/homebrew/bin/flock  |  Intel: /usr/local/bin/flock
FLOCK="$(command -v flock 2>/dev/null || echo /opt/homebrew/bin/flock)"
readonly FLOCK

# -----------------------------------------------------------------------------
# Logging — writes to syslog, visible in Console.app or via:
#   log show --predicate 'senderImagePath contains "syslog"' --last 1h
# -----------------------------------------------------------------------------
log_info() { syslog -s -l notice "${LOG_TAG}: $*"; }
log_error() { syslog -s -l error "${LOG_TAG}: $*"; }

# -----------------------------------------------------------------------------
# Sanity checks
# -----------------------------------------------------------------------------
if [[ "${EUID}" -ne 0 ]]; then
    echo "ERROR: This script must run as root (wdutil requires sudo)." >&2
    exit 1
fi

if ! command -v wdutil &>/dev/null; then
    log_error "wdutil not found — is this macOS 11+?"
    exit 1
fi

if [[ ! -x "${FLOCK}" ]]; then
    log_error "flock not found at ${FLOCK}. Install via: brew install util-linux"
    exit 1
fi

# -----------------------------------------------------------------------------
# Acquire script-level lock via flock.
#
# -x  : exclusive lock
# -n  : non-blocking — exit immediately if lock is already held
# FD 9: the lock file descriptor, opened below via exec
#
# This prevents two cron invocations from overlapping (e.g. if a previous
# run is still copying a large backlog of log data).
# -----------------------------------------------------------------------------
exec 9>"${LOCKFILE}"
if ! "${FLOCK}" -xn 9; then
    log_info "Another instance is already running (lock held). Exiting."
    exit 0
fi
# Lock is held for the remainder of this script; released automatically on exit.

# -----------------------------------------------------------------------------
# is_wdutil_running
#
# Returns 0 (true) if the PID in PIDFILE exists and corresponds to a live
# wdutil process. Returns 1 otherwise.
#
# Checks:
#   1. Pidfile exists and contains a valid integer.
#   2. kill -0 succeeds (process is alive).
#   3. Process name contains "wdutil" (guards against PID reuse after reboot).
# -----------------------------------------------------------------------------
is_wdutil_running() {
    [[ -f "${PIDFILE}" ]] || return 1

    local pid
    pid=$(<"${PIDFILE}")
    [[ "${pid}" =~ ^[0-9]+$ ]] || return 1

    kill -0 "${pid}" 2>/dev/null || return 1

    local procname
    procname=$(ps -p "${pid}" -o comm= 2>/dev/null || true)
    [[ "${procname}" == *wdutil* ]] || return 1

    return 0
}

# -----------------------------------------------------------------------------
# start_wdutil
#
# Launches `wdutil log +wifi` detached from this shell. stdout/stderr are
# forwarded to syslog via `logger`. The PID is written to PIDFILE.
#
# Waits up to 10 seconds for SOURCE to appear before proceeding.
# -----------------------------------------------------------------------------
start_wdutil() {
    log_info "Starting wdutil log +wifi"

    wdutil log +wifi > >(logger -t wdutil || true) 2>&1 &
    local pid=$!

    echo "${pid}" >"${PIDFILE}"
    log_info "wdutil started with PID ${pid}"

    # Wait for wdutil to create /tmp/wifi.log
    local retries=10
    while [[ ! -f "${SOURCE}" && ${retries} -gt 0 ]]; do
        sleep 1
        ((retries--)) || true
    done

    if [[ ! -f "${SOURCE}" ]]; then
        log_error "wdutil started (PID ${pid}) but ${SOURCE} never appeared."
        exit 1
    fi

    log_info "${SOURCE} is ready."
}

# -----------------------------------------------------------------------------
# copy_new_data
#
# Reads OFFSETFILE to determine how many bytes have already been copied,
# then appends only new bytes from SOURCE to DEST using `tail -c +N`.
#
# `tail -c +N` outputs from byte N to EOF (1-indexed), so to skip `offset`
# bytes we start at offset+1.
#
# Handles source truncation (e.g. /tmp cleared by a reboot) by detecting
# when current_size < offset and resetting the offset to 0.
# -----------------------------------------------------------------------------
copy_new_data() {
    mkdir -p "$(dirname "${DEST}")"

    # Read previously recorded byte offset (default 0)
    local offset=0
    if [[ -f "${OFFSETFILE}" ]]; then
        offset=$(<"${OFFSETFILE}")
        [[ "${offset}" =~ ^[0-9]+$ ]] || offset=0
    fi

    # Current size of source in bytes; `wc -c` pads with spaces on macOS
    local current_size
    current_size=$(wc -c <"${SOURCE}" 2>/dev/null | tr -d ' ')

    # Detect truncation — /tmp was cleared (reboot) and wdutil restarted fresh
    if [[ "${current_size}" -lt "${offset}" ]]; then
        log_info "Source truncated (was ${offset}B, now ${current_size}B) — resetting offset."
        {
            printf '\n'
            local ts
            ts=$(date)
            printf '=== wifi_log_manager: log reset at %s (likely reboot) ===\n' "${ts}"
            printf '\n'
        } >>"${DEST}"
        offset=0
    fi

    # Nothing new to copy
    if [[ "${current_size}" -le "${offset}" ]]; then
        log_info "No new data (${current_size}B total, ${offset}B already copied)."
        return 0
    fi

    local new_bytes=$((current_size - offset))

    # Append only the new portion — tail -c +N is 1-indexed
    tail -c +"$((offset + 1))" "${SOURCE}" >>"${DEST}"

    log_info "Appended ${new_bytes}B to ${DEST} (total source: ${current_size}B)."

    echo "${current_size}" >"${OFFSETFILE}"
}

# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
main() {
    log_info "Running."

    # shellcheck disable=SC2310
    if is_wdutil_running; then
        log_info "wdutil already running (PID $(<"${PIDFILE}"))."
    else
        # Clean up any stale pidfile before starting fresh
        rm -f "${PIDFILE}"
        start_wdutil
    fi

    copy_new_data

    log_info "Done."
}

main
