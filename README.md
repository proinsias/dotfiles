# dotfiles

My personal collection of dotfiles to be managed with
[chezmoi](https://www.chezmoi.io/).

<!-- editorconfig-checker-disable -->
<!-- markdownlint-disable line-length -->

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/proinsias/dotfiles/main.svg)](https://results.pre-commit.ci/latest/github/proinsias/dotfiles/main)

<!-- editorconfig-checker-enable -->

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
/bin/bash -c "$(curl -fsSL \
    https://raw.githubusercontent.com/proinsias/dotfiles/refs/heads/main/bin/install-homebrew-op)"
# Setup all but the encrypted files.
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply proinsias \
    --exclude encrypted
cd ~/.local/share/chezmoi

# Save age key from 1password to disk.
./bin/get-age-key

# Save git-crypt key from 1password to disk:
# ~/.config/git-crypt/dotfiles.bin

# De-crypt everything:
git-crypt unlock ~/.config/git-crypt/dotfiles.bin

# Apply everything.
chezmoi apply
```

## Migration from age to git-crypt

Repeat the following for each repository file ending in `.age`.

```bash
chezmoi forget "${file}"
```

Commit changes to remove any `encrypted_` files.

Set encryption to "transparent":

```
chezmoi edit-config
```

Update .gitattributes to add filter for `encrypted_` files.

```
git-crypt init
git-crypt export-key ~/.config/git-crypt/dotfiles.bin
git-crypt unlock ~/.config/git-crypt/dotfiles.bin

# Add back in each sensitive file:
chezmoi add --encrypt ~/.config/file

git-crypt status -e
```

## To Dos

1. Setup /etc/hosts -> see `hosts` file.
