# dotfiles

My personal collection of dotfiles to be managed with
[chezmoi](https://www.chezmoi.io/).

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/proinsias/dotfiles/main.svg)](https://results.pre-commit.ci/latest/github/proinsias/dotfiles/main)

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

Simply run this command from your terminal.

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply proinsias
```

## To Dos

1. ml/devskim
1. ml/shellcheck
1. ml/EDITORCONFIG
1. ml/gitleaks
1. ml/kics
1. .doom.d -> ilovemovies
1. gpg private keys -> ilovemovies?
1. mv .zsh*files to ~/.config/zsh/*
1. gitconfig - Switch to getting from op!
1. Convert zsh aliases to chezmoi template.

-   [ ] /etc/hosts

```shell
───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ File: /etc/hosts
───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
1 │ # Host Database
2 │ #
3 │ # localhost is used to configure the loopback interface
4 │ # when the system is booting. Do not change this entry.
5 │ ##
6 │ 127.0.0.1 localhost
7 │ # Disable Cryptohacking - <https://www.grc.com/sn/SN-637-Notes.pdf>
8 │ 127.0.0.1 coin-hive.com coinhive.com
9 │ # Disable AudienceInsights - <https://www.grc.com/sn/SN-644-Notes.pdf>
10 │ 127.0.0.1 static.audienceinsights.net
11 │ 127.0.0.1 api.behavioralengine.com
12 │ 255.255.255.255 broadcasthost
13 │ ::1 localhost
14 │ # Added by Docker Desktop
15 │ # To allow the same kube context to work on the host and the container:
16 │ 127.0.0.1 kubernetes.docker.internal
17 │ # End of section
───────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

```
