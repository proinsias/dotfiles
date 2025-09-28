#!/usr/bin/env bash

set -o errexit                # Exit on error. Append || true if you expect an error.
set -o errtrace               # Exit on error inside any functions or subshells.
set -o noclobber              # Don't allow overwriting files.
set -o nounset                # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail               # Produce a failure return code if any pipeline command errors.
shopt -s failglob             # Cause globs that don't get expanded to cause errors.
shopt -s globstar 2>/dev/null # Match all files and zero or more sub-directories.

# editorconfig-checker-disable-next-line
npx mega-linter-runner --env "'ENABLE_LINTERS=PYTHON_BLACK,PYTHON_ISORT,PYTHON_BANDIT,PYTHON_PYRIGHT,ACTION_ACTIONLINT,BASH_SHELLCHECK,BASH_SHFMT,COPYPASTE_JSCPD,EDITORCONFIG_EDITORCONFIG_CHECKER,JSON_JSONLINT,JSON_V8R,JSON_PRETTIER,MARKDOWN_MARKDOWN_TABLE_FORMATTER,REPOSITORY_DUSTILOCK,REPOSITORY_GIT_DIFF,REPOSITORY_GRYPE,REPOSITORY_KICS,REPOSITORY_SECRETLINT,REPOSITORY_SYFT,REPOSITORY_TRIVY,REPOSITORY_TRIVY_SBOM,REPOSITORY_TRUFFLEHOG,YAML_PRETTIER,YAML_YAMLLINT,YAML_V8R'" \
    --env 'SHOW_ELAPSED_TIME=true' \
    --env 'FLAVOR_SUGGESTIONS=false'
