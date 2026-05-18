---
allowed-tools:
    Bash(gh issue view:*), Bash(gh search:*), Bash(gh issue list:*), Bash(gh pr
    diff:*), Bash(gh pr view:*), Bash(gh pr list:*), Bash(git commit:*),
    Bash(git add:*), Bash(git diff:*)
description: Iteratively code review and fix a PR until no issues score above 75
disable-model-invocation: false
---

You are running an iterative code review and fix loop on the given pull request.

## Parameters (extract from user input)

- PR: the pull request number or URL
- MAX_ITERATIONS: maximum fix cycles before stopping (default: 3)
- TIME_LIMIT: soft time guidance in minutes (default: 20)

## Loop protocol

1. Record the start time mentally. After each iteration, estimate elapsed time.
   If you have exceeded TIME_LIMIT, stop and go directly to the final report.

2. Run up to MAX_ITERATIONS fix cycles. Each cycle:

    a. **Review phase**: Run the full code review protocol from
    `custom-code-review` (the 7-agent parallel review + confidence scoring).
    Collect all issues with confidence score > 75.

    b. **Gate check**: If no issues score above 75, exit the loop immediately.

    c. **Fix phase**: For each issue scoring > 75, in descending score order:
    - Read the relevant file and line range
    - Propose and apply a fix directly to the working tree
    - Write a brief justification for the fix

    d. **Iteration summary**: Record iteration number, issues found, issues
    fixed, and any issues that were skipped (with reason).

3. After MAX_ITERATIONS cycles (or early exit), produce the final report below.

## Final report format

---

### Iterative Review Report

Completed N of MAX_ITERATIONS iterations. Stopped because: <reason>.

#### Fixes Applied

| Iter | Issue | Score | Fix summary |
| ---- | ----- | ----- | ----------- |
| 1    | ...   | 90    | ...         |

#### Remaining Issues (score ≤ 75 or unfixed)

<use the standard custom-code-review report format for these>

#### Issues Not Fixed (score > 75 but skipped)

<list with reason, e.g. "required architectural change outside PR scope">

---

## Hard stops

Stop the loop early if any of the following occur:

- No issues score above 75 (success)
- MAX_ITERATIONS reached
- Estimated elapsed time exceeds TIME_LIMIT
- The same issue recurs across 2 consecutive iterations unchanged (cycle
  detection — flag it and skip rather than loop infinitely)
