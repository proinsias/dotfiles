# dotfiles

My personal collection of dotfiles to be managed with
[chezmoi](https://www.chezmoi.io/).

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/proinsias/dotfiles/main.svg)](https://results.pre-commit.ci/latest/github/proinsias/dotfiles/main) <!-- editorconfig-checker-disable-line --> <!-- markdownlint-disable line-length -->

## Table of contents

<!--
Table of contents updated via:
uvx --from md-toc md_toc --in-place github -- README.md
-->
<!--TOC-->

-   [dotfiles](#dotfiles)
    -   [Table of contents](#table-of-contents)
    -   [Install](#install)
    -   [To Dos](#to-dos)

<!--TOC-->

## Install

Simply run these commands from your terminal.

```shell
# Install homebrew and 1password CLI ahead.
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/proinsias/dotfiles/refs/heads/main/bin/install-homebrew-op)"
# Setup all but the encrypted files.
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply proinsias \
    --exclude encrypted
cd ~/.local/share/chezmoi
# Save age key from 1password to disk.
./bin/get-age-key
# Apply everything.
chezmoi apply
```

## To Dos

1. Setup /etc/hosts -> see `hosts` file.
