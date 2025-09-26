# dotfiles_chezmoi

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

## Extras

chezmoi update

## To Dos

1. Handle .doom.d
1. How handle .oh-my-zsh/custom/aliases.zsh ?
1. TEST installing.

```
if type op >/dev/null 2>&1; then
    if ! test -f "${HOME}"/.config/op/plugins/brew.json; then
        op signin
        op plugin init brew
    fi

    if ! test -f "${HOME}"/.config/op/plugins/gh.json; then
        op signin
        op plugin init gh
    fi

    # op plugin init aws
    # op plugin init cdk  # AWS CDK
    # op plugin init dog  # DataDog
    # op plugin init huggingface-cli
    # op plugin init kaggle
    # op plugin init mysql
    # op plugin init ngrok
    # op plugin init okta
    # op plugin init openai
    # op plugin init psql
    # op plugin init snowsql
fi
```

```
───────┬───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
       │ File: /etc/hosts
───────┼───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
   1   │ # Host Database
   2   │ #
   3   │ # localhost is used to configure the loopback interface
   4   │ # when the system is booting.  Do not change this entry.
   5   │ ##
   6   │ 127.0.0.1 localhost
   7   │ # Disable Cryptohacking - https://www.grc.com/sn/SN-637-Notes.pdf
   8   │ 127.0.0.1 coin-hive.com coinhive.com
   9   │ # Disable AudienceInsights - https://www.grc.com/sn/SN-644-Notes.pdf
  10   │ 127.0.0.1   static.audienceinsights.net
  11   │ 127.0.0.1   api.behavioralengine.com
  12   │ 255.255.255.255 broadcasthost
  13   │ ::1             localhost
  14   │ # Added by Docker Desktop
  15   │ # To allow the same kube context to work on the host and the container:
  16   │ 127.0.0.1 kubernetes.docker.internal
  17   │ # End of section
───────┴───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────


```

Eventually, overwrite dotfiles directory with this repo's contents!
