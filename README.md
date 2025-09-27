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

.aider
.aspnet
.bun
.cache -> move?
.cargo
.CFUserTextEncoding
.cookiecutter_replay
.cookiecutters
.crawl4ai
.cups
.docker
.dotnet
.dropbox
.dwagent
.exrc
.fzf.bash
.fzf.zsh
.gdbinit
.gdl.setup
.gk
.gk
.gnupg
.httpie
.hunspell_default
.idl.setup
.inputrc
.ipython
.jupyter
.kaggle
.keras
.kshrc
.lesshst
.llamafile
.local
.matplotlib
.mogrc
.netrc
.npm
.npmrc
.ntfy.yml
.oh-my-zsh
.ollama
.prettierignore
.profile
.pyenv
.pylintrc
.pypirc
.pytensor
.python_history
.rubocop.yml
.safety
.screenrc
.shellcheckrc
.slackcat
.sonarlint
.ssh
.subversion
.tcshrc
.tldr
.tmux.conf
.user.profile
.viminfo
.vimrc
.vnc
.vscode
.vscode-oss
.wakatime
.wakatime-internal.cfg
.wakatime.cfg
.wdm
.wgetrc
.yamllint.yml
.yarn
.zfunc
.zlogin
.zlogout
.zprofile
.zsh_history
.zsh_sessions
.zshenv
.zshrc

.config:
archey4
atuin
broot
butterfish
cheat
chezmoi
curlrc
devbox
direnv

dot_bash
dot_bash_completions
dot_bash_logout
dot_bash_profile
dot_bashrc.tmpl

dot_bundle
dot_direnvrc
dot_editorconfig
dot_envrc.tmpl
dot_exrc
dot_gdbinit
dot_gdl.setup.tmpl
dot_gemrc.tmpl
dot_httpie
dot_hunspell_default
dot_idl.setup.tmpl
dot_inputrc
dot_ipython
dot_jupyter
dot_kshrc
dot_local
dot_mogrc
dot_netrc.tmpl
dot_npmrc
dot_ntfy.yml.tmpl
dot_profile.tmpl
dot_pylintrc
dot_rubocop.yml
dot_screenrc
dot_shellcheckrc
dot_ssh
dot_subversion

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
