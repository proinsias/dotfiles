#!/usr/bin/env bats
# Tests for bin/get-brew-diffs
#
# Strategy: stub `brew` to write controlled content to the --file argument,
# and redirect HOME to a temp directory containing a fake Brewfile.

# shellcheck disable=SC2154  # BATS_TEST_DIRNAME is set by the BATS runner
SCRIPT="${BATS_TEST_DIRNAME}/../../bin/get-brew-diffs"

setup() {
    STUB_DIR=$(mktemp -d)
    HOME_DIR=$(mktemp -d)
    mkdir -p "${HOME_DIR}/.config/homebrew"
    export PATH="${STUB_DIR}:${PATH}"
    export HOME="${HOME_DIR}"
    export BREW_STUB_RESPONSE="${STUB_DIR}/brew-response"

    # Stub brew: writes the response file contents to --file <path>.
    cat >"${STUB_DIR}/brew" <<'STUB'
#!/usr/bin/env bash
while [[ $# -gt 0 ]]; do
    if [[ "$1" == "--file" ]]; then
        cp "${BREW_STUB_RESPONSE}" "$2"
        exit 0
    fi
    shift
done
STUB
    chmod +x "${STUB_DIR}/brew"
}

teardown() {
    rm -rf "${STUB_DIR}" "${HOME_DIR}"
}

# ---------------------------------------------------------------------------
# Files match — diff should exit 0
# ---------------------------------------------------------------------------

@test "exits 0 when brew dump matches the Brewfile" {
    printf "brew 'wget'\n" >"${HOME_DIR}/.config/homebrew/Brewfile"
    printf "brew 'wget'\n" >"${BREW_STUB_RESPONSE}"
    run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}

@test "produces no output when files are identical" {
    printf "brew 'wget'\n" >"${HOME_DIR}/.config/homebrew/Brewfile"
    printf "brew 'wget'\n" >"${BREW_STUB_RESPONSE}"
    run bash "${SCRIPT}"
    [[ -z "${output}" ]]
}

# ---------------------------------------------------------------------------
# Files differ — diff should exit non-zero
# ---------------------------------------------------------------------------

@test "exits non-zero when brew dump differs from the Brewfile" {
    printf "brew 'wget'\n" >"${HOME_DIR}/.config/homebrew/Brewfile"
    printf "brew 'curl'\n" >"${BREW_STUB_RESPONSE}"
    run bash "${SCRIPT}"
    [[ "${status}" -ne 0 ]]
}

@test "diff output includes the changed package name when files differ" {
    printf "brew 'wget'\n" >"${HOME_DIR}/.config/homebrew/Brewfile"
    printf "brew 'curl'\n" >"${BREW_STUB_RESPONSE}"
    run bash "${SCRIPT}"
    [[ "${output}" == *"curl"* ]]
}
