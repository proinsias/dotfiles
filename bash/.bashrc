# User dependent .bashrc file
# Anything you'd want at an interactive non-login shell. Command prompt, `EDITOR`
# variable, bash aliases for my use.
# only output stuff in interactive mode.

# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# Source global definitions
if test -f /etc/bashrc; then
    . /etc/bashrc
fi

# For homebrew
# Adds $HOMEBREW_PREFIX/bin as prefix to PATH.
case $(uname -s) in
"Linux")
    # homebrew linuxbrew
    test -d /home/linuxbrew/.linuxbrew && OUTPUT="$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" && eval "${OUTPUT}"
    # shellcheck disable=SC2086
    test -d "${HOME}/.linuxbrew/" && OUTPUT="$(${HOME}/.linuxbrew/bin/brew shellenv)" && eval "${OUTPUT}"
    ;;
"Darwin")
    # Intel homebrew
    test -f /usr/local/bin/brew && OUTPUT="$(/usr/local/bin/brew shellenv)" && eval "${OUTPUT}"
    # M1 home-brew – do second in case we are also using Intel
    # via Rosetta.
    test -f /opt/homebrew/bin/brew && OUTPUT="$(/opt/homebrew/bin/brew shellenv)" && eval "${OUTPUT}"

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
    ;;
*) ;;

esac

# Shell Options
#
# See man bash for more options...
#
# Don't use ^D to exit
set -o ignoreeof
#
# Don't wait for job termination notification
# set -o notify
#
# command name that is directory name is executed as if it were argument to cd
# shellcheck disable=SC2065
shopt -s autocd 2>/dev/null
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell
#
# List the status of any stopped and running jobs before exiting
shopt -s checkjobs
#
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
#
# Save all lines of a multiple-line command in the same history entry
shopt -s cmdhist
#
# Correct spelling of directory names during word completion
shopt -s dirspell
#
# Include filenames beginning with '.' in results of filename expansion
shopt -s dotglob
#
# '**' used in filename expansion context will match all files and zero or
# more directories and subdirectories. If pattern is followed by '/', only directories
# and subdirectories match.
# shellcheck disable=SC2065
shopt -s globstar 2>/dev/null
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# Give opportunity to re-edit a failed history substitution
shopt -s histreedit
#
# Results of history substitution not immediately passed to the shell parser
shopt -s histverify
#
# Save multi-line commands to the history with embedded newlines
shopt -s lithist
#
# Use case-insensitive filename globbing
shopt -s nocaseglob

# Create venv directory in case doesn't exist.
mkdir -p "${HOME}"/.virtualenvs

# source .bashrc.local and .bashrc.local.<blah>
# shellcheck disable=SC2065
if /bin/ls "${HOME}"/.bashrc.local* >/dev/null 2>&1; then
    for file in "${HOME}"/.bashrc.local*; do
        # shellcheck disable=SC1090
        source "${file}"
    done
    unset file
fi

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1

## pipx (https://github.com/pipxproject/pipx)
# shellcheck disable=SC2065
if type pipx >/dev/null 2>&1; then
    OUTPUT="$(register-python-argcomplete pipx)"
    eval "${OUTPUT}"
else
    echo "Install pipx using: brew install pipx"
fi

# AWS bash completion
complete -C aws_completer aws

# tab completion for conda
# shellcheck disable=SC2065
if type conda >/dev/null 2>&1; then
    # shellcheck disable=SC2065
    if type register-python-argcomplete >/dev/null 2>&1; then
        OUTPUT="$(register-python-argcomplete conda)"
        eval "${OUTPUT}"
    else
        echo "Install argcomplete using: python3 -m pip install argcomplete"
    fi
fi

# tab completion for whalebrew
# shellcheck disable=SC2065
if type whalebrew >/dev/null 2>&1; then
    OUTPUT="$(whalebrew completion bash)"
    eval "${OUTPUT}"
fi

# Global tab completion for argcomplete-supported apps
# shellcheck disable=SC2154
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete"; then
    # shellcheck disable=SC2065
    if type activate-global-python-argcomplete >/dev/null 2>&1; then
        activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
    else
        echo "Install argcomplete using: python3 -m pip install argcomplete"
    fi
fi

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
# shellcheck disable=SC2065
if test -f "${HOME}"/.bash_completions/git-completion.sh >/dev/null 2>&1; then
    source "${HOME}"/.bash_completions/git-completion.sh
fi

# https://python-poetry.org/docs/
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/poetry.bash-completion"; then
    # shellcheck disable=SC2065
    if test poetry >/dev/null 2>&1; then
        poetry completions bash >"${HOMEBREW_PREFIX}"/etc/bash_completion.d/poetry.bash-completion
    else
        echo "Install poetry!"
    fi
fi

# npm completion > "${HOME}"/.bash_completions/npm-completion.sh
# shellcheck disable=SC2065
if test -f "${HOME}"/.bash_completions/npm-completion.sh >/dev/null 2>&1; then
    source "${HOME}"/.bash_completions/npm-completion.sh
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# shellcheck disable=SC2086,SC2312
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ${HOME}/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

# For homebrew bash completion
# shellcheck disable=SC2065
if test -f "${HOMEBREW_PREFIX}/etc/bash_completion" >/dev/null 2>&1; then
    # shellcheck disable=SC1091
    . "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

# The next line enables shell command completion for gcloud.
if [[ -f '/usr/local/google-cloud-sdk/completion.bash.inc' ]]; then
    . '/usr/local/google-cloud-sdk/completion.bash.inc'
fi

export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3

if [[ -f "${HOME}/.bash/cht.sh" ]]; then
    # https://cheat.sh/
    . "${HOME}/.bash/cht.sh"
fi

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL="${HISTCONTROL}${HISTCONTROL+,}ignoredups"
#
# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
# export HISTIGNORE=$'[ \t]*:&:[fb]g:exit'
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls' # Ignore the ls command as well
#
# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND="history -a"

# Disable the clearing of the screen by less
# Pass color ANSI control characters through to the terminal
export LESS="-XR"

# Don't clear the screen after quitting a manual page
export MANPAGER="less -X"

export EDITOR='emacsclient'
if [[ -n "${EDITOR}" && -z "${VISUAL}" ]]; then
    export VISUAL="${EDITOR}"
fi

export GIT_EDITOR=emacsclient
export ALTERNATE_EDITOR=""

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
WHITE="\[\033[1;37m\]"
PS1="${GREEN}\u@\h ${YELLOW}\w ${RED}\$(parse_git_branch)${WHITE} [\!]\n\$ "

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file";
#done;
#unset file;

# shellcheck disable=SC2065
if brew command command-not-found-init >/dev/null 2>&1; then
    OUTPUT="$(brew command-not-found-init)"
    eval "${OUTPUT}"
fi

# Warn of missing tools
# shellcheck disable=SC2065
if ! type hub >/dev/null 2>&1; then
    echo "Install hub using: brew install hub"
fi

export PATH="${HOME}/.local/bin${PATH:+:${PATH}}"

## fzf
# shellcheck disable=SC2065
if type fzf >/dev/null 2>&1; then
    if ! test -f "${HOME}"/.fzf.bash; then
        "${HOMEBREW_PREFIX}/opt/fzf/install" --all --no-update-rc
    fi
    if test -f "${HOME}"/.fzf.bash; then
        source "${HOME}"/.fzf.bash
    fi
else
    echo "Install fzf using: brew install fzf"
fi

# Add keychain keys - use 1password instead for ssh key
# shellcheck disable=SC2065
if type keychain >/dev/null 2>&1; then
    OUTPUT="$(keychain --eval --agents gpg --ignore-missing --inherit any 6519D396 740CFB25 97FAE23F)"
    eval "${OUTPUT}"
else
    echo "Install keychain using: brew install keychain"
fi

# # Add 1password-cli session
# shellcheck disable=SC2065
if type op >/dev/null 2>&1; then
    OUTPUT="$(op signin --account slesnonovans)"
    eval "${OUTPUT}"
else
    echo "Install 1password-cli using: brew cask install 1password-cli"
fi

case $(uname -s) in
"Linux")
    # function cleanup {
    #     echo "Killing SSH-Agent"
    #
    #     # shellcheck disable=SC2065
    #     rm -rf "$(ls -ld /tmp/ssh-*fodonovan* | awk '{print $9}')" >/dev/null 2>&1
    #     # shellcheck disable=SC2065,SC2154
    #     kill -9 "${SSH_AGENT_PID}" >/dev/null 2>&1
    # }
    # 2016-05-31 - commented below to debug sudden exits
    # trap cleanup EXIT

    # https://github.com/KittyKatt/screenFetch
    # shellcheck disable=SC2065
    if type screenfetch >/dev/null 2>&1; then
        screenfetch
    fi
    ;;
"Darwin")

    # https://github.com/obihann/archey-osx
    # shellcheck disable=SC2065
    if type archey >/dev/null 2>&1; then
        archey
    else
        echo "Install archey using: brew install archey4"
    fi
    # https://github.com/dylanaraps/neofetch
    # shellcheck disable=SC2065
    if type neofetch >/dev/null 2>&1; then
        neofetch
    else
        echo "Install neofetch using: brew install neofetch"
    fi

    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

    # homebrew openssh with keychain support doesn't work anymore?
    # Below use Apple's ssh-add, rather than brew ssh-add
    # Move to interactive-only part
    # No need to launch ssh-agent - should be done by default
    # /usr/bin/ssh-add -l &> /dev/null || /usr/bin/ssh-add -K # ~/.ssh/id_rsa

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

    # Disable per-session command history feature in El Capitan
    # <https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan>
    export SHELL_SESSION_HISTORY=0
    ;;
*) ;;

esac

# Use `/bin/ls` for these tests, since homebrew `ls` gives errors
# shellcheck disable=SC2065
if /bin/ls "${HOME}"/.bash/* 1>/dev/null 2>&1; then
    for file in "${HOME}"/.bash/*; do
        # shellcheck disable=SC1090
        source "${file}"
    done
    unset file
fi

# source .bash_aliases and .bash_aliases.local.<blah>
# shellcheck disable=SC2065
if /bin/ls "${HOME}"/.bash_aliases* 1>/dev/null 2>&1; then
    for file in "${HOME}"/.bash_aliases*; do
        # shellcheck disable=SC1090
        source "${file}"
    done
    unset file
fi

# A utility for sending notifications, on demand and when commands finish.
# https://github.com/dschep/ntfy/
# shellcheck disable=SC2065
if type ntfy >/dev/null 2>&1; then
    OUTPUT="$(ntfy shell-integration --foreground-too)"
    eval "${OUTPUT}"
    export AUTO_NTFY_DONE_IGNORE="aws-shell ec emacs glances ipython jupyter man meld ""\
psql screen tmux vim"
fi

### https://github.com/chrisallenlane/cheat
### cheat allows you to create and view interactive cheatsheets on the command-line.
export CHEATCOLORS=true

### https://github.com/clvv/fasd
### Offers quick access to files and directories
# shellcheck disable=SC2065
if type fasd >/dev/null 2>&1; then
    OUTPUT="$(fasd --init auto)"
    eval "${OUTPUT}"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && OUTPUT="$(SHELL=/bin/sh lesspipe)" && eval "${OUTPUT}"

# "Magnificent app which corrects your previous console command"
# shellcheck disable=SC2065
if type thefuck >/dev/null 2>&1; then
    OUTPUT="$(thefuck --alias)"
    eval "${OUTPUT}"
else
    echo "Install thefuck using: brew install thefuck"
fi

# pyenv
# shellcheck disable=SC2065
if type pyenv >/dev/null 2>&1; then
    OUTPUT="$(pyenv init --path)" # Puts shims dir as prefix to PATH.
    eval "${OUTPUT}"
    OUTPUT="$(pyenv init -)"
    eval "${OUTPUT}"
    OUTPUT="$(pyenv virtualenv-init -)"
    eval "${OUTPUT}"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    # eval "$(pipenv --completion)"
else
    echo "Install pyenv using: brew install pyenv"
fi

# Don't need this with use of keychain.
# ssh-add -A  # Add all identities stored in your keychain.
# ssh-add ~/.ssh/id_rsa
# To add identities, run:
# ssh-add -K ~/.ssh/id_rsa

# Starship
# shellcheck disable=SC2065
if type starship >/dev/null 2>&1; then
    OUTPUT="$(starship init bash)"
    eval "${OUTPUT}"
else
    echo "Install starship using: brew install starship"
fi

### http://direnv.net/
# shellcheck disable=SC2065
if type direnv >/dev/null 2>&1; then
    OUTPUT="$(direnv hook bash)"
    eval "${OUTPUT}"
else
    echo "Install direnv using: brew install direnv"
fi

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
# if test -f "${HOME}"/.bashhub/bashhub.sh > /dev/null 2>&1; then
#   source "${HOME}"/.bashhub/bashhub.sh
# fi

# shellcheck disable=SC2065
if test -f "${HOME}"/.config/broot/launcher/bash/br >/dev/null 2>&1; then
    source "${HOME}"/.config/broot/launcher/bash/br
fi

# To enable support via ssh-add.
export SSH_AUTH_SOCK=~/.1password/agent.sock

# nbp bash completion
# shellcheck disable=SC2065
if type nbp >/dev/null 2>&1; then
    # shellcheck disable=SC2065
    if ! test -f "${HOME}"/.bash_completions/nbp.sh >/dev/null 2>&1; then
        nbp --install-completion bash
    fi
    # shellcheck disable=SC2065
    if test -f "${HOME}"/.bash_completions/nbp.sh >/dev/null 2>&1; then
        source "${HOME}"/.bash_completions/nbp.sh
    fi
else
    echo "Install nbp using: pipx install nbpreview"
fi

# Deduplicate PATH variable
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
export PATH

### Print message of the day.

# istheinternetonfire.com
# shellcheck disable=SC2065
if ping -c 1 google.com >/dev/null 2>&1; then
    echo "Is the internet on fire?:"
    dig +short -t txt istheinternetonfire.com
fi

# pyjokes
# shellcheck disable=SC2065
if type pyjoke >/dev/null 2>&1; then
    echo
    echo "Joke of the Day:"
    pyjoke
fi

# tldr
# shellcheck disable=SC2065
if type tldr >/dev/null 2>&1; then
    echo
    echo "tldr random example"
    tldr --random-example
fi

# motd
# shellcheck disable=SC2065
if type motd >/dev/null 2>&1; then
    echo
    echo "tip of the day"
    motd
fi

echo
