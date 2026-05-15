#!/usr/bin/env bash
# =============================================================================
# wifi_log_manager.sh
#
# Enables wifi logging via `wdutil log +wifi`, then calls `wdutil dump` to
# capture the current buffer and appends it to a persistent log on your Desktop.
#
# Designed to be run periodically via cron, e.g. every 15 minutes:
#   */15 * * * * /path/to/wifi_log_manager.sh
#
# Uses `flock` (Homebrew util-linux) to guarantee only one instance runs at a
# time.
#
# Must run as root — wdutil requires elevated privileges.
#
# Files managed:
#   LOCKFILE : /var/run/wifi_log_manager.lock  — flock exclusive lock
#   DEST     : ~/Desktop/wifi_capture.log      — persistent output
# =============================================================================

set -euo pipefail

# -----------------------------------------------------------------------------
# Configuration
# -----------------------------------------------------------------------------
readonly DEST="${HOME}/Desktop/wifi_capture.log"
readonly LOCKFILE="/var/run/wifi_log_manager.lock"
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
# -----------------------------------------------------------------------------
exec 9>"${LOCKFILE}"
if ! "${FLOCK}" -xn 9; then
    log_info "Another instance is already running (lock held). Exiting."
    exit 0
fi

# -----------------------------------------------------------------------------
# dump_wifi
#
# Ensures wifi logging is enabled, then calls `wdutil dump` to flush the
# in-memory buffer to /tmp/wifi-XXXXXX.log. Locates that file via a sentinel
# (a temp file created just before the dump, used as a -newer reference for
# find), appends its contents to DEST, then removes the dump file.
# -----------------------------------------------------------------------------
dump_wifi() {
    mkdir -p "$(dirname "${DEST}")"

    # Enable wifi logging — idempotent one-shot command, exits immediately.
    wdutil log +wifi

    # Sentinel lets us identify the dump file even though its name is random.
    local sentinel
    sentinel=$(mktemp /tmp/wifi_sentinel.XXXXXX)
    # Ensure sentinel mtime is strictly before the dump.
    sleep 1

    wdutil dump

    # Collect all dump files created after the sentinel.
    local -a dump_files=()
    local find_out
    find_out=$(find /tmp -maxdepth 1 -name 'wifi-*.log' -newer "${sentinel}" 2>/dev/null) || true
    while IFS= read -r f; do
        dump_files+=("${f}")
    done <<<"${find_out}"

    rm -f "${sentinel}"

    if [[ ${#dump_files[@]} -eq 0 ]]; then
        log_error "wdutil dump ran but no /tmp/wifi-*.log file appeared."
        return 1
    fi

    local total_bytes=0
    for f in "${dump_files[@]}"; do
        local size
        size=$(wc -c <"${f}" | tr -d ' ')
        cat "${f}" >>"${DEST}"
        rm -f "${f}"
        ((total_bytes += size)) || true
    done

    log_info "Appended ${total_bytes}B from ${#dump_files[@]} dump file(s) to ${DEST}."
}

# -----------------------------------------------------------------------------
# main
# -----------------------------------------------------------------------------
main() {
    log_info "Running."
    dump_wifi
    log_info "Done."
}

main
