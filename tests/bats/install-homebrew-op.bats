#!/usr/bin/env bats
# Tests for bin/install-homebrew-op
#
# Strategy: restrict PATH to STUB_DIR plus basic system bins, stub `uname`
# to return "Linux" (avoids macOS hardcoded brew paths that cannot be mocked),
# and stub external commands (brew, nb, op, curl) as no-ops.  When testing
# "tool missing" branches, simply omit that tool's stub.  The curl stub returns
# empty output so the `bash -c ""` fallback is a silent no-op.

# shellcheck disable=SC2154  # BATS_TEST_DIRNAME is set by the BATS runner
SCRIPT="${BATS_TEST_DIRNAME}/../../bin/install-homebrew-op"

setup() {
    STUB_DIR=$(mktemp -d)
}

teardown() {
    rm -rf "${STUB_DIR}"
}

# Write a trivial no-op stub for the named command.
_stub() {
    local name="$1"
    printf '#!/usr/bin/env bash\nexit 0\n' >"${STUB_DIR}/${name}"
    chmod +x "${STUB_DIR}/${name}"
}

# Write a uname stub that reports the given OS string for `-s`.
_stub_uname() {
    local os="$1"
    printf '#!/usr/bin/env bash\necho "%s"\n' "${os}" >"${STUB_DIR}/uname"
    chmod +x "${STUB_DIR}/uname"
}

# ---------------------------------------------------------------------------
# All tools already installed
# ---------------------------------------------------------------------------

@test "exits 0 when brew, nb, and op are all already installed" {
    _stub_uname "Linux"
    _stub brew
    _stub nb
    _stub op
    _stub curl
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}

@test "produces no 'Installing' output when all tools are present" {
    _stub_uname "Linux"
    _stub brew
    _stub nb
    _stub op
    _stub curl
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${output}" != *"Installing"* ]]
}

# ---------------------------------------------------------------------------
# brew missing
# ---------------------------------------------------------------------------

@test "prints 'Installing Homebrew...' when brew is absent" {
    _stub_uname "Linux"
    _stub nb
    _stub op
    _stub curl
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${output}" == *"Installing Homebrew"* ]]
}

# ---------------------------------------------------------------------------
# nb missing
# ---------------------------------------------------------------------------

@test "prints 'Installing Nanobrew...' when nb is absent" {
    _stub_uname "Linux"
    _stub brew
    _stub op
    _stub curl
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${output}" == *"Installing Nanobrew"* ]]
}

# ---------------------------------------------------------------------------
# op missing — unknown OS falls through to the warning branch
# ---------------------------------------------------------------------------

@test "prints 'Installing 1Password CLI...' when op is absent" {
    _stub_uname "UnknownOS"
    _stub brew
    _stub nb
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${output}" == *"Installing 1Password CLI"* ]]
}

@test "prints a warning when op is absent and OS is unrecognized" {
    _stub_uname "UnknownOS"
    _stub brew
    _stub nb
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${output}" == *"No method to install 1Password CLI found"* ]]
}

@test "still exits 0 when op is absent and OS is unrecognized" {
    _stub_uname "UnknownOS"
    _stub brew
    _stub nb
    PATH="${STUB_DIR}:/usr/bin:/bin" run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}
