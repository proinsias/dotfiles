#!/usr/bin/env bats
# Tests for chezmoi/dot_local/bin/executable_copyright-year.
#
# The script is designed as a git pre-commit hook: it iterates over
# files staged for commit (via `git diff-index --cached --name-only HEAD`)
# and checks that any file containing a "Copyright " notice also includes
# the current year (and optionally the holder from hooks.copyrightholder).
#
# Strategy: each test spins up a temporary git repository so the script
# can run against real staged files without touching the main repo.

SCRIPT="${BATS_TEST_DIRNAME}/../../chezmoi/dot_local/bin/executable_copyright-year"
YEAR=$(date +%Y)

setup() {
    REPO_DIR=$(mktemp -d)
    cd "${REPO_DIR}" || return 1
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    # Create HEAD so git diff-index has something to diff against.
    git commit --allow-empty -m "initial commit"
}

teardown() {
    cd / || true
    rm -rf "${REPO_DIR}"
}

# ---------------------------------------------------------------------------
# --about flag
# ---------------------------------------------------------------------------

@test "--about prints a description and exits 0" {
    run bash "${SCRIPT}" --about
    [ "$status" -eq 0 ]
    [[ "$output" == *"copyright"* ]]
}

# ---------------------------------------------------------------------------
# Files with no copyright line — always pass regardless of content
# ---------------------------------------------------------------------------

@test "file with no copyright line: exits 0" {
    echo "Just some code, no copyright here." > no-copyright.txt
    git add no-copyright.txt
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# Files with an up-to-date copyright — should pass
# ---------------------------------------------------------------------------

@test "file with copyright bearing the current year: exits 0" {
    echo "# Copyright ${YEAR} Someone" > valid.txt
    git add valid.txt
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

@test "file with multi-year copyright range including current year: exits 0" {
    echo "# Copyright 2019-${YEAR} Someone" > range.txt
    git add range.txt
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

# ---------------------------------------------------------------------------
# Files with an outdated copyright year — should fail
# ---------------------------------------------------------------------------

@test "file with copyright from a past year only: exits non-zero" {
    echo "# Copyright 2020 Someone" > outdated.txt
    git add outdated.txt
    run bash "${SCRIPT}"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Error"* ]]
}

# ---------------------------------------------------------------------------
# hooks.copyrightholder is configured
# ---------------------------------------------------------------------------

@test "copyright has current year and matching holder: exits 0" {
    git config hooks.copyrightholder "Alice"
    echo "# Copyright ${YEAR} Alice" > valid-holder.txt
    git add valid-holder.txt
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

@test "copyright has current year but wrong holder: exits non-zero" {
    git config hooks.copyrightholder "Alice"
    echo "# Copyright ${YEAR} Bob" > wrong-holder.txt
    git add wrong-holder.txt
    run bash "${SCRIPT}"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Error"* ]]
}

@test "copyright has matching holder but wrong year: exits non-zero" {
    git config hooks.copyrightholder "Alice"
    echo "# Copyright 2020 Alice" > old-year-holder.txt
    git add old-year-holder.txt
    run bash "${SCRIPT}"
    [ "$status" -ne 0 ]
    [[ "$output" == *"Error"* ]]
}

# ---------------------------------------------------------------------------
# Edge cases
# ---------------------------------------------------------------------------

@test "unstaged file with outdated copyright is not checked" {
    echo "# Copyright 2020 Someone" > unstaged.txt
    # deliberately NOT staged — git diff-index won't list it
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

@test "staged deleted file (no longer on disk) is skipped gracefully" {
    echo "# Copyright 2020 Someone" > to-delete.txt
    git add to-delete.txt
    git commit -m "add file to delete"
    git rm to-delete.txt
    # File is staged for deletion and does not exist on disk;
    # test_file() should return early without error.
    run bash "${SCRIPT}"
    [ "$status" -eq 0 ]
}

@test "multiple staged files: only the outdated one triggers failure" {
    echo "# Copyright ${YEAR} Someone" > current.txt
    echo "# No copyright here"         > no-cr.txt
    echo "# Copyright 2019 Someone"   > old.txt
    git add current.txt no-cr.txt old.txt
    run bash "${SCRIPT}"
    [ "$status" -ne 0 ]
}
