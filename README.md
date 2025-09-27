# dotfiles

My personal collection of dotfiles to be managed with
[chezmoi](https://www.chezmoi.io/).

## Table of contents

<!--
Table of contents updated via:
uvx --from md-toc md_toc --in-place github -- README.md
-->
<!--TOC-->

-   [dotfiles_chezmoi](#dotfiles_chezmoi)
    -   [Table of contents](#table-of-contents)
    -   [Install](#install)
    -   [Extras](#extras)
    -   [To Dos](#to-dos)

<!--TOC-->

## Install

Simply run this command from your terminal.

```shell
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply proinsias
```

## To Dos

.doom.d -> ilovemovies
gpg private keys -> ilovemovies?

1. run chezmoi unmanaged on work
1. mv .zsh* files to ~/.config/zsh/*
1. gitconfig - Switch to getting from op!
1. Convert zsh aliases to chezmoi template.

```
-   [ ] /etc/hosts

```

───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
│ File: /etc/hosts
───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
1 │ # Host Database
2 │ #
3 │ # localhost is used to configure the loopback interface
4 │ # when the system is booting. Do not change this entry.
5 │ ##
6 │ 127.0.0.1 localhost
7 │ # Disable Cryptohacking - https://www.grc.com/sn/SN-637-Notes.pdf
8 │ 127.0.0.1 coin-hive.com coinhive.com
9 │ # Disable AudienceInsights - https://www.grc.com/sn/SN-644-Notes.pdf
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

```
