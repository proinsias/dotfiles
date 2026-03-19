#!/usr/bin/env bats
# Tests for chezmoi/dot_local/bin/executable_check-freespace
# and chezmoi/dot_local/bin/executable_freespace (identical logic).
#
# Strategy: inject a fake `df` earlier on PATH that returns controlled
# output so tests are deterministic regardless of actual disk usage.

SCRIPT_CHECK="${BATS_TEST_DIRNAME}/../../chezmoi/dot_local/bin/executable_check-freespace"
SCRIPT_FREE="${BATS_TEST_DIRNAME}/../../chezmoi/dot_local/bin/executable_freespace"

# Column layout expected by the scripts' awk:
#   $1 Filesystem  $2 1K-blocks  $3 Used  $4 Available  $5 Use%  $6 Mounted-on

setup() {
    STUB_DIR=$(mktemp -d)
    export PATH="${STUB_DIR}:${PATH}"
}

teardown() {
    rm -rf "${STUB_DIR}"
}

# Write a fake `df` that reports the given Available value in column 4.
_stub_df() {
    local available="${1}"
    printf '#!/usr/bin/env bash\necho "Filesystem 1K-blocks Used Available Use%% Mounted"\necho "/dev/sda1 20480000 5120000 %s 50%% /"\n' \
        "${available}" > "${STUB_DIR}/df"
    chmod +x "${STUB_DIR}/df"
}

# ---------------------------------------------------------------------------
# --about flag
# ---------------------------------------------------------------------------

@test "check-freespace --about prints description and exits 0" {
    run bash "${SCRIPT_CHECK}" --about
    [ "$status" -eq 0 ]
    [ "$output" = "Check if there is less then 100MB of free space." ]
}

@test "freespace --about prints description and exits 0" {
    run bash "${SCRIPT_FREE}" --about
    [ "$status" -eq 0 ]
    [ "$output" = "Check if there is less then 100MB of free space." ]
}

# ---------------------------------------------------------------------------
# check-freespace behaviour
# ---------------------------------------------------------------------------

@test "check-freespace: no warning when space is plentiful (10 GB)" {
    _stub_df 10240000
    run bash "${SCRIPT_CHECK}" 2>&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "check-freespace: no warning at exactly the 100 MB threshold" {
    # threshold is strictly less-than 102400, so 102400 should not warn
    _stub_df 102400
    run bash "${SCRIPT_CHECK}" 2>&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "check-freespace: warning printed to stderr when 1 kB below threshold" {
    _stub_df 102399
    run bash "${SCRIPT_CHECK}" 2>&1
    [ "$status" -eq 0 ]
    [[ "$output" == *"Warning"* ]]
}

@test "check-freespace: warning printed to stderr when space is very low (50 MB)" {
    _stub_df 51200
    run bash "${SCRIPT_CHECK}" 2>&1
    [ "$status" -eq 0 ]
    [[ "$output" == *"less then 100MB"* ]]
}

# ---------------------------------------------------------------------------
# freespace behaviour (same logic, duplicate coverage for confidence)
# ---------------------------------------------------------------------------

@test "freespace: no warning when space is plentiful (10 GB)" {
    _stub_df 10240000
    run bash "${SCRIPT_FREE}" 2>&1
    [ "$status" -eq 0 ]
    [ -z "$output" ]
}

@test "freespace: warning printed to stderr when space is very low (50 MB)" {
    _stub_df 51200
    run bash "${SCRIPT_FREE}" 2>&1
    [ "$status" -eq 0 ]
    [[ "$output" == *"Warning"* ]]
}
