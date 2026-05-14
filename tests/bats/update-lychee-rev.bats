#!/usr/bin/env bats
# Tests for chezmoi/dot_local/bin/executable_update-lychee-rev
#
# Strategy: inject a fake `git` earlier on PATH whose ls-remote output is
# controlled by a response file, keeping tests deterministic and offline.
# The script references CONFIG=".pre-commit-config.yaml" relative to CWD,
# so each test cd's into a temporary working directory.

SCRIPT="${BATS_TEST_DIRNAME}/../../chezmoi/dot_local/bin/executable_update-lychee-rev"

setup() {
    STUB_DIR=$(mktemp -d)
    WORK_DIR=$(mktemp -d)
    export PATH="${STUB_DIR}:${PATH}"
    cd "${WORK_DIR}" || return 1
}

teardown() {
    cd / || true
    rm -rf "${STUB_DIR}" "${WORK_DIR}"
}

# Install a fake `git` that serves controlled ls-remote output from a file.
# Real git invocations are passed through via `command git`.
_stub_git() {
    local response_file="${STUB_DIR}/ls-remote-response"
    printf '%s' "$1" >"${response_file}"
    export GIT_STUB_RESPONSE="${response_file}"
    cat >"${STUB_DIR}/git" <<'STUB'
#!/usr/bin/env bash
if [[ "$1" == "ls-remote" ]]; then
    cat "${GIT_STUB_RESPONSE}"
else
    command git "$@"
fi
STUB
    chmod +x "${STUB_DIR}/git"
}

# Realistic ls-remote output: three semver tags each with a peeled ^{} entry.
# Listed out of lexicographic order to exercise sort -V behaviour.
_typical_tags() {
    printf 'abc1\trefs/tags/v0.9.0\n'
    printf 'abc2\trefs/tags/v0.9.0^{}\n'
    printf 'abc3\trefs/tags/v0.14.0\n'
    printf 'abc4\trefs/tags/v0.14.0^{}\n'
    printf 'abc5\trefs/tags/v0.10.2\n'
    printf 'abc6\trefs/tags/v0.10.2^{}\n'
}

# ---------------------------------------------------------------------------
# Error: ls-remote returns no usable tags
# ---------------------------------------------------------------------------

@test "exits non-zero when git ls-remote returns nothing" {
    _stub_git ""
    touch .pre-commit-config.yaml
    run bash "${SCRIPT}" 2>&1
    [ "$status" -ne 0 ]
}

# ---------------------------------------------------------------------------
# Happy path: config has rev: nightly
# ---------------------------------------------------------------------------

@test "replaces 'rev: nightly' with the latest tag and exits 0" {
    _stub_git "$(_typical_tags)"
    cat >.pre-commit-config.yaml <<'EOF'
repos:
    - repo: https://github.com/lycheeverse/lychee
      rev: nightly
      hooks:
          - id: lychee
EOF
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
    grep -q 'rev: v0.14.0' .pre-commit-config.yaml
    ! grep -q 'rev: nightly' .pre-commit-config.yaml
}

@test "stdout reports the version and the substitution when updated" {
    _stub_git "$(_typical_tags)"
    printf 'rev: nightly\n' >.pre-commit-config.yaml
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Latest lychee version: v0.14.0"* ]]
    [[ "$output" == *"Updated .pre-commit-config.yaml"* ]]
}

# ---------------------------------------------------------------------------
# Config has no rev: nightly — nothing to update
# ---------------------------------------------------------------------------

@test "exits 0 with 'nothing to update' when config lacks rev: nightly" {
    _stub_git "$(_typical_tags)"
    cat >.pre-commit-config.yaml <<'EOF'
repos:
    - repo: https://github.com/lycheeverse/lychee
      rev: v0.14.0
      hooks:
          - id: lychee
EOF
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
    [[ "$output" == *"nothing to update"* ]]
}

# ---------------------------------------------------------------------------
# Version selection
# ---------------------------------------------------------------------------

@test "picks the highest semantic version even when tags arrive out of sort order" {
    _stub_git "$(printf 'a\trefs/tags/v0.14.0\nb\trefs/tags/v0.10.2\nc\trefs/tags/v0.9.0\n')"
    printf 'rev: nightly\n' >.pre-commit-config.yaml
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
    [[ "$output" == *"v0.14.0"* ]]
}

@test "peeled tag entries (^{}) do not appear in the selected version" {
    _stub_git "$(_typical_tags)"
    printf 'rev: nightly\n' >.pre-commit-config.yaml
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
    [[ "$output" != *"^{}"* ]]
    grep -q 'rev: v0.14.0' .pre-commit-config.yaml
}
