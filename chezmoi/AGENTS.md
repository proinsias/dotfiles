# Development Guidelines

## Philosophy

### Core Beliefs

- **Incremental progress over big bangs** - Small changes that compile and pass
  tests
- **Learning from existing code** - Study and plan before implementing
- **Pragmatic over dogmatic** - Adapt to project reality
- **Clear intent over clever code** - Be boring and obvious

### Simplicity

- **Single responsibility** per function/class
- **Avoid premature abstractions**
- **No clever tricks** - choose the boring solution
- If you need to explain it, it's too complex

## Feedback Style

- Be direct and critical when evaluating my suggestions — point out flaws,
  trade-offs, and better alternatives even if I seem committed to an approach
- Do not soften criticism to be polite — I prefer honest technical pushback over
  validation

## AI Workflow

- Read existing code and understand the codebase before writing anything
- Propose a plan for complex tasks before implementing — wait for approval
- Implement incrementally in small, reviewable pieces
- Reuse existing functions and modules — do not duplicate logic
- Flag over-engineering, poor naming, and duplicated logic in your own output
- Be critical of your own suggestions

## Technical Standards

### Architecture Principles

- **Composition over inheritance** - Use dependency injection
- **Interfaces over singletons** - Enable testing and flexibility
- **Explicit over implicit** - Clear data flow and dependencies
- **Test-driven when possible** - Never disable tests, fix them

### Error Handling

- **Fail fast** with descriptive messages
- **Include context** for debugging
- **Handle errors** at appropriate level
- **Never** silently swallow exceptions

## Project Integration

### Learn the Codebase

- Find similar features/components
- Identify common patterns and conventions
- Use same libraries/utilities when possible
- Follow existing test patterns

### Tooling

- Use project's existing build system
- Use project's existing test framework
- Use project's formatter/linter settings
- Don't introduce new tools without strong justification

### Code Style

- Follow existing conventions in the project
- Refer to linter configurations and .editorconfig, if present
- Text files should always end with an empty line
- Markdown files should always have no markdownlint errors

## MCP Tool Use

- Use Context7 to validate current documentation about software libraries

## Important Reminders

**NEVER**:

- Use `--no-verify` to bypass commit hooks
- Disable tests instead of fixing them
- Commit code that doesn't compile
- Make assumptions - verify with existing code

**ALWAYS**:

- Commit working code incrementally
- Update code documentation as you go if needed
- Update plan documentation as you go
- Always explain abbreviations used in documentation
- Learn from existing implementations
- Stop after 3 failed attempts and reassess

## Code reviews

- When performing code reviews, always output the review as a structured report
  to stdout. Never edit source files unless explicitly asked to make changes.
- Ensure GitHub CLI (`gh`) is authenticated before attempting PR-based
  workflows. Run `gh auth status` first and report if not authenticated rather
  than failing mid-review.

## Git usage

- Use conventional commits: `feat:`, `fix:`, `refactor:`, `test:`, `docs:`,
  `chore:`
- Require at least one peer review before merging
- Commit `poetry.lock` and `uv.lock` always — never `.gitignore` them
- Before committing, be aware that pre-commit hooks (ruff, hadolint, shellcheck)
  may fail and require retries. If a commit fails due to pre-commit auto-fixes,
  re-stage the fixed files and retry rather than trying to work around the
  hooks.
- Check if the current project uses Python with pytest for testing, ruff for
  linting, and pre-commit hooks. Always run `pytest` after code changes and
  `ruff check` before committing if appropriate

## Refactoring

When asked to find or list things (magic numbers, missing tests, redundant
config), list ALL matches comprehensively before asking if the user wants
changes. Do not start refactoring until explicitly confirmed.

## Security and Privacy

- Never commit: `.env`, credentials, API keys, large data files, notebook
  outputs, `__pycache__`
- Never commit directly to `main` or `production` branches — always use PRs
- Never log PHI, PII, or secrets — no exceptions
- Never store credentials in repo — use environment variables or AWS Secrets
  Manager

## Graphite Workflow (ALWAYS USE FOR STACKED PRs)

**CRITICAL: When working with stacked PRs, ALWAYS use Graphite (gt) commands
instead of git push/pull**

- **Push changes**: Use `gt submit` (NOT `git push`)
- **Sync with remote**: Use `gt sync` (NOT `git pull` or `git fetch`)
- **Restack branches**: Use `gt restack` when parent branches change
- **Switch branches**: Use `gt checkout <branch>` (same as git)

**NEVER use these when working with stacked PRs:**

- ❌ `git push --force-with-lease` (causes divergence)
- ❌ `git push` (bypasses Graphite tracking)
- ❌ `git pull` (use `gt sync` instead)

**Why**: Using git commands directly bypasses Graphite's tracking and causes
branches to diverge between local and remote, leading to duplicate code in PRs.

## Code Quality

- DO NOT add "...", symbols, or emojis to comments
- No commented-out code in commits — use git history
- No bare `except:` — always catch specific exception types
- Define custom exception types for application-specific errors
- Use `logging` module, never `print()`
- Use structured/JSON logging so logs can be queried by monitoring tools
- Use `pathlib.Path`, never string paths
- No `sys.path` manipulation — configure `pyproject.toml` for imports instead
- Replace magic numbers with named constants; add comments explaining rationale
  where the name alone is insufficient
- Always cite source methodologies, papers, or Confluence pages in comments for
  numerical methods and algorithms

## Python

- Python 3.11+, PEP 8, max 100 chars per line
- Double quotes `"` for strings
- Type hints on all function signatures and class attributes
- Google-style docstrings on all public functions, classes, and modules —
  include Args, Returns, Raises, Examples
- Use doctests in Examples sections so they stay in sync with implementation
- Pydantic for configuration and settings management
- Pandera or Pydantic models for data schema validation at all input/output
  boundaries
- Parallelize loops over long iterables when possible
- Prefer vectorized pandas operations over `iterrows()`
- Implement caching for expensive computations or repeated data fetches

## Code Organization

- Single responsibility: each module, class, and function does one task — if
  it's hard to name, it does too much
- Use `src/` layout with domain-driven organization
- Prefer dependency injection over global state or singletons
- Use `typing.Protocol` to define interfaces for major components
- Separate configuration from code

## Testing

- pytest, `test_<function>_<scenario>()` naming, mirror `src/` structure in
  `tests/`
- Target 80%+ overall coverage; 100% for critical paths (model inference, data
  pipelines, billing)
- Use `pytest.mark.integration` to flag integration tests so they can be
  excluded during dev
- All new functions in `src/` must have tests

## Environment

- On SageMaker, Poetry is at:
  `/home/sagemaker-user/.local/share/pypoetry/venv/bin/poetry`
- Always run scripts via `poetry run python ...`

## Reference Guides (load on demand)

- Python style, naming, error handling, logging: @best_practices/python-style.md
- Testing strategy and coverage: @best_practices/testing.md
- Security, credentials, PHI/PII: @best_practices/security.md
- Dependency management with Poetry: @best_practices/poetry.md
- Jupyter notebooks and R&D practices: @best_practices/notebooks.md
- Git, code review, repo requirements: @best_practices/git.md
- Deployment and CI/CD: @best_practices/deployment.md
- Working with AI coding assistants: @best_practices/ai-development.md
