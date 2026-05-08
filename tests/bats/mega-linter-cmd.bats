#!/usr/bin/env bats
# Tests for bin/mega-linter-cmd
#
# Strategy: stub `npx` to capture its arguments to a file so tests can
# assert what was passed without running the real mega-linter-runner.

# shellcheck disable=SC2154  # BATS_TEST_DIRNAME is set by the BATS runner
SCRIPT="${BATS_TEST_DIRNAME}/../../bin/mega-linter-cmd"

setup() {
    STUB_DIR=$(mktemp -d)
    NPX_ARGS_FILE="${STUB_DIR}/npx-args"
    export NPX_ARGS_FILE
    export PATH="${STUB_DIR}:${PATH}"

    cat >"${STUB_DIR}/npx" <<'STUB'
#!/usr/bin/env bash
printf '%s\n' "$@" >"${NPX_ARGS_FILE}"
exit 0
STUB
    chmod +x "${STUB_DIR}/npx"
}

teardown() {
    rm -rf "${STUB_DIR}"
}

# ---------------------------------------------------------------------------
# Exit status
# ---------------------------------------------------------------------------

@test "exits 0" {
    run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}

# ---------------------------------------------------------------------------
# npx invocation
# ---------------------------------------------------------------------------

@test "invokes mega-linter-runner via npx" {
    run bash "${SCRIPT}"
    grep -q 'mega-linter-runner' "${NPX_ARGS_FILE}"
}

@test "passes ENABLE_LINTERS env flag" {
    run bash "${SCRIPT}"
    grep -q 'ENABLE_LINTERS' "${NPX_ARGS_FILE}"
}

@test "passes SHOW_ELAPSED_TIME=true" {
    run bash "${SCRIPT}"
    grep -q 'SHOW_ELAPSED_TIME=true' "${NPX_ARGS_FILE}"
}

@test "passes FLAVOR_SUGGESTIONS=false" {
    run bash "${SCRIPT}"
    grep -q 'FLAVOR_SUGGESTIONS=false' "${NPX_ARGS_FILE}"
}

# ---------------------------------------------------------------------------
# Linter coverage spot-checks
# ---------------------------------------------------------------------------

@test "ENABLE_LINTERS includes BASH_SHELLCHECK" {
    run bash "${SCRIPT}"
    grep -q 'BASH_SHELLCHECK' "${NPX_ARGS_FILE}"
}

@test "ENABLE_LINTERS includes PYTHON_BLACK" {
    run bash "${SCRIPT}"
    grep -q 'PYTHON_BLACK' "${NPX_ARGS_FILE}"
}

@test "ENABLE_LINTERS includes REPOSITORY_TRIVY" {
    run bash "${SCRIPT}"
    grep -q 'REPOSITORY_TRIVY' "${NPX_ARGS_FILE}"
}
