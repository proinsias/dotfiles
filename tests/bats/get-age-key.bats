#!/usr/bin/env bats
# Tests for bin/get-age-key
#
# Strategy: stub `op` to return controlled key material and redirect HOME
# to a temp directory, keeping tests offline and non-destructive.

# shellcheck disable=SC2154  # BATS_TEST_DIRNAME is set by the BATS runner
SCRIPT="${BATS_TEST_DIRNAME}/../../bin/get-age-key"

setup() {
    STUB_DIR=$(mktemp -d)
    HOME_DIR=$(mktemp -d)
    export PATH="${STUB_DIR}:${PATH}"
    export HOME="${HOME_DIR}"

    cat >"${STUB_DIR}/op" <<'STUB'
#!/usr/bin/env bash
# $1 = "read", $2 = op:// URI
if [[ "$2" == "op://Parents/chezmoi/public-key" ]]; then
    echo "AGE1TESTPUBKEY"
elif [[ "$2" == "op://Parents/chezmoi/key.txt" ]]; then
    printf 'AGE-SECRET-KEY-1TESTSECRETKEY\n'
fi
STUB
    chmod +x "${STUB_DIR}/op"
}

teardown() {
    rm -rf "${STUB_DIR}" "${HOME_DIR}"
}

# ---------------------------------------------------------------------------
# Exit status
# ---------------------------------------------------------------------------

@test "exits 0" {
    run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}

# ---------------------------------------------------------------------------
# File creation
# ---------------------------------------------------------------------------

@test "creates ~/.config/chezmoi/key.txt" {
    run bash "${SCRIPT}"
    [[ -f "${HOME_DIR}/.config/chezmoi/key.txt" ]]
}

@test "creates ~/.config/mise/age.txt" {
    run bash "${SCRIPT}"
    [[ -f "${HOME_DIR}/.config/mise/age.txt" ]]
}

# ---------------------------------------------------------------------------
# File contents
# ---------------------------------------------------------------------------

@test "key.txt contains the public key comment line" {
    run bash "${SCRIPT}"
    grep -q '# public key: AGE1TESTPUBKEY' "${HOME_DIR}/.config/chezmoi/key.txt"
}

@test "key.txt contains the secret key" {
    run bash "${SCRIPT}"
    grep -q 'AGE-SECRET-KEY-1TESTSECRETKEY' "${HOME_DIR}/.config/chezmoi/key.txt"
}

@test "age.txt has the same content as key.txt" {
    run bash "${SCRIPT}"
    diff "${HOME_DIR}/.config/chezmoi/key.txt" "${HOME_DIR}/.config/mise/age.txt"
}
