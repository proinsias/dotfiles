# Test Coverage Analysis

## Executive Summary

The repository has **zero unit or integration tests** despite having pytest configured and
installed. The sole CI workflow performs shallow smoke tests (chezmoi apply + shell startup),
runs only weekly, and covers only macOS/zsh. Several testable scripts contain bugs that a
test suite would have caught. This document catalogues the gaps and proposes concrete
improvements ordered by impact.

---

## Current State

| Metric | Status |
|---|---|
| Unit test files | **0** |
| Shell test files (bats/shunit2) | **0** |
| CI triggers | Weekly cron + manual dispatch only |
| CI matrix | macOS + zsh only (Ubuntu & bash commented out) |
| Coverage reporting | None |
| Pytest installed | Yes (via `run_onchange_after_04-install-uv-packages-pytest.sh.tmpl`) |
| Pre-commit linting | Strong (shellcheck, ruff, pyright, yamllint, …) |

The gap is almost total: linting runs, but no behaviour is verified.

---

## Bugs Found That Tests Would Have Caught

### 1. `executable_auto-sync.py` — crashed error handler (line 86)

```python
# line 86
prilogger.errornt(f"[{time.ctime()}] STDERR: {e.stderr.decode()}")
```

`prilogger` is not defined anywhere. This is a typo for `logger.error(...)`. Because this
line is inside the `except subprocess.CalledProcessError` block, any git failure silently
crashes the error-reporting path itself. A unit test that mocked a failing subprocess call
would have surfaced this immediately as a `NameError`.

### 2. `executable_copyright-year` — inverted logic (lines 49–59)

```bash
# With cr_holder set:
if grep 'Copyright ' "${file}" | grep "${year}" | grep "${cr_holder}" >/dev/null; then
    echo "Error: ${file} seems to be missing a copyright string …"
    exit 1
fi
```

The script exits with an error when grep **succeeds** (i.e., the copyright IS present). The
correct check needs `grep -v` or a `! grep` negation. The same inversion exists in the
`else` branch (lines 56–59). A bats test with a file containing a valid copyright would
expose this — the script would erroneously fail.

---

## Priority Areas for Improvement

### Priority 1 — Python unit tests (`executable_auto-sync.py`)

**Why:** Python is the most testable language in the repo and this file contains meaningful
logic with real bugs.

**What to test:**

- `git_sync()` happy path: verify `git add`, `git status`, `git commit`, `git pull`, `git push`
  are called in the right order with the right arguments (mock `subprocess.run`).
- `git_sync()` — no changes: when `git status --porcelain` returns empty output, `git commit`
  must **not** be called.
- `git_sync()` — failure path: when any subprocess raises `CalledProcessError`, the error is
  logged without raising (and the `NameError` on line 86 would be caught immediately).
- `GitEventHandler.on_any_event()` — `.git` path ignored: events with `.git` in `src_path`
  must not trigger `git_sync`.
- `GitEventHandler.on_any_event()` — debounce: a second event within `SYNC_INTERVAL_SECONDS`
  must not call `git_sync` again.
- `GitEventHandler.on_any_event()` — debounce expiry: an event after the interval elapses
  must call `git_sync`.

**Suggested location:** `tests/test_auto_sync.py`

**Tools:** `pytest`, `pytest-mock` (already in `pytest-reqs.txt`).

---

### Priority 2 — Shell script tests for `bin/` utilities

**Why:** These scripts are used in real workflows and have no automated verification at all.

**What to test (using [bats-core](https://github.com/bats-core/bats-core)):**

#### `executable_copyright-year`

- A file with a valid `Copyright <year> <holder>` line should exit 0.
- A file with a copyright but the wrong year should exit 1.
- A file with no copyright line should exit 0 (not checked).
- `--about` flag should print a description and exit 0.
*(This would expose the inverted-logic bug immediately.)*

#### `executable_check-freespace`

- Mock `df` output with > 100 MB available → no warning printed to stderr.
- Mock `df` output with < 100 MB available → warning printed to stderr.
- `--about` flag should print description.

#### `executable_replace`

- Verify the `ag | xargs sed` pipeline produces correct substitutions in a temp file.
- Test that missing arguments produce a useful error (currently unhandled — `$1` and `$2`
  are unguarded when script is called with no args under `set -o nounset`).

**Suggested location:** `tests/bats/`

**Tools:** `bats-core`, add to `mise.toml` or install via Homebrew.

---

### Priority 3 — CI workflow improvements

**Why:** The current workflow only runs weekly, only on macOS, and excludes encrypted files
and scripts from the chezmoi apply. Regressions can sit for a week undetected.

#### 3a — Run CI on pull requests and pushes to `main`

Uncomment the disabled triggers in `.github/workflows/test-dotfiles.yml`:

```yaml
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  schedule:
    - cron: 1 2 * * 4
  workflow_dispatch:
```

#### 3b — Re-enable the Ubuntu matrix entry

```yaml
matrix:
  os: [ubuntu-latest, macos-latest]
  shell: [bash, zsh]
```

This would surface macOS-specific script flags (e.g., `sed -i ''` in `executable_replace`
fails on GNU sed; `df . -k` column layout differs between BSD and GNU).

#### 3c — Add shellcheck to CI explicitly

shellcheck already runs via pre-commit, but adding it as a dedicated CI step makes failures
visible in the PR checks panel:

```yaml
- name: Run shellcheck on bin/ scripts
  run: shellcheck bin/* chezmoi/dot_local/bin/executable_*
```

#### 3d — Run pytest in CI once unit tests exist

```yaml
- name: Run unit tests
  run: |
    uv run --with pytest --with pytest-mock \
      pytest tests/ --tb=short
```

---

### Priority 4 — Chezmoi template validation

**Why:** The 52 `.sh.tmpl` scripts use Go templating with data values from `.chezmoi.toml`.
There is no test that exercises the `work = true` / `lite = true` branches.

**What to test:**

- Add a second test config (`chezmoi/.test.chezmoi.work.toml`) with `work = true` and run
  `chezmoi apply --dry-run` to verify the work-specific template branches render without
  errors.
- Repeat for `lite = true`.
- Consider `chezmoi execute-template` in CI to lint individual templates.

---

### Priority 5 — `executable_murder` (Ruby) basic smoke tests

**Why:** The argument-dispatch logic (`is_pid`, `is_port`, `is_name`) contains branching that
is untested.

**What to test:**

- `i?("123")` returns truthy; `i?("ruby")` returns falsy.
- `i?("")` returns falsy.
- `main` dispatches correctly based on the argument type (mock the `murder_*` functions).

**Tools:** `minitest` (stdlib) or `rspec`.

---

### Priority 6 — `executable_auto-sync.py` — REPO_PATHS validation

The main block skips non-existent paths with a log warning but exits if **no** paths are
valid. There is no test that verifies:

- Mixed valid/invalid paths: valid ones are watched, invalid ones are skipped.
- All invalid paths: exits with code 1.

These are pure integration scenarios testable with `tmp_path` fixtures in pytest.

---

## Recommended Implementation Order

1. Fix the two known bugs (#1 and #2 above) — these are regressions with no test to prevent
   recurrence.
2. Add `bats-core` to `mise.toml` and write bats tests for `executable_copyright-year` and
   `executable_check-freespace` — small, self-contained, high confidence.
3. Write pytest unit tests for `executable_auto-sync.py` — highest LOC, most logic.
4. Enable CI on push/PR and restore the Ubuntu matrix — zero code required, immediate
   coverage gain.
5. Add chezmoi template variant testing for `work`/`lite` branches.
6. Add Ruby tests for `executable_murder` if it sees regular changes.

---

## Testing Infrastructure Gaps to Address

| Gap | Suggested Fix |
|---|---|
| No test runner entry point | Add `pytest tests/` to `Makefile` or `mise` task |
| No coverage reporting | Add `pytest-cov`; set minimum threshold (e.g., 80%) |
| bats-core not installed | Add `bats-core` to `mise.toml` |
| No Linux test in CI | Re-enable `ubuntu-latest` in the matrix |
| CI not triggered on PRs | Uncomment push/pull_request triggers |
| `bin/op` stub too minimal | Expand the fake `op` to return structured JSON so scripts that parse op output can be tested end-to-end |
