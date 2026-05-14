#!/usr/bin/env bats
# Tests for bin/op — the fake 1Password CLI stub used in CI.

# shellcheck disable=SC2154  # BATS_TEST_DIRNAME is set by the BATS runner
SCRIPT="${BATS_TEST_DIRNAME}/../../bin/op"

@test "op exits successfully" {
    run bash "${SCRIPT}"
    [[ "${status}" -eq 0 ]]
}

@test "op outputs 'default-value'" {
    run bash "${SCRIPT}"
    [[ "${output}" = "default-value" ]]
}

@test "op ignores extra arguments" {
    run bash "${SCRIPT}" read "op://vault/item/field"
    [[ "${status}" -eq 0 ]]
    [[ "${output}" = "default-value" ]]
}
