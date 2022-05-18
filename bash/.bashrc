# User dependent .bashrc file
# Anything you'd want at an interactive non-login shell. Command prompt, `EDITOR`
# variable, bash aliases for my use.
# only output stuff in interactive mode.

# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# Source global definitions
if test -f /etc/bashrc ; then
  . /etc/bashrc
fi

# For homebrew
# Adds $HOMEBREW_PREFIX/bin as prefix to PATH.
case $(uname -s) in
    "Linux" )
        # homebrew linuxbrew
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        test -d "${HOME}/.linuxbrew/" && eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"
        ;;
    "Darwin" )
        # Intel homebrew
        test -f /usr/local/bin/brew && eval "$(/usr/local/bin/brew shellenv)"
        # M1 home-brew – do second in case we are also using Intel
        # via Rosetta.
        test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"
        ;;
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
shopt -s autocd 2> /dev/null
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
shopt -s globstar 2> /dev/null
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
if /bin/ls "${HOME}"/.bashrc.local* > /dev/null 2>&1; then
  for file in "${HOME}"/.bashrc.local*; do
    source "${file}"
  done;
  unset file;
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
if type pipx > /dev/null 2>&1 ; then
    eval "$(register-python-argcomplete pipx)"
else
    echo "Install pipx using: brew install pipx"
fi

# AWS bash completion
complete -C aws_completer aws

# tab completion for conda
if type conda > /dev/null 2>&1 ; then
  if type register-python-argcomplete > /dev/null 2>&1 ; then
    eval "$(register-python-argcomplete conda)"
  else
    echo "Install argcomplete using: python3 -m pip install argcomplete"
  fi
fi

# Global tab completion for argcomplete-supported apps
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete"; then
  if type activate-global-python-argcomplete > /dev/null 2>&1 ; then
    activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
  else
    echo "Install argcomplete using: python3 -m pip install argcomplete"
  fi
fi

# https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
if test -f "${HOME}"/.bash_completions/git-completion.sh > /dev/null 2>&1; then
    source "${HOME}"/.bash_completions/git-completion.sh
fi

# npm completion > "${HOME}"/.bash_completions/npm-completion.sh
if test -f "${HOME}"/.bash_completions/npm-completion.sh > /dev/null 2>&1; then
    source "${HOME}"/.bash_completions/npm-completion.sh
fi

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "${HOME}/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ${HOME}/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# For homebrew bash completion
if test -f "${HOMEBREW_PREFIX}/etc/bash_completion" > /dev/null 2>&1; then
    . "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/google-cloud-sdk/completion.bash.inc' ]; then
  . '/usr/local/google-cloud-sdk/completion.bash.inc'
fi

export CLOUDSDK_PYTHON=/opt/homebrew/bin/python3

if [ -f "${HOME}/.bash/cht.sh" ]; then
  # https://cheat.sh/
  . "${HOME}/.bash/cht.sh"
fi

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL="$HISTCONTROL${HISTCONTROL+,}ignoredups"
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
export MANPAGER="less -X";

export EDITOR='emacsclient'
if [[ -n "${EDITOR}" && -z "${VISUAL}" ]] ; then
  export VISUAL="${EDITOR}"
fi

export GIT_EDITOR=emacsclient
export ALTERNATE_EDITOR=""

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
WHITE="\[\033[1;37m\]"
PS1="$GREEN\u@\h $YELLOW\w $RED\$(parse_git_branch)$WHITE [\!]\n\$ "

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don't want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file";
#done;
#unset file;

if brew command command-not-found-init > /dev/null 2>&1; then
  eval "$(brew command-not-found-init)";
fi

# Warn of missing tools
if ! type hub > /dev/null 2>&1 ; then
  echo "Install hub using: brew install hub"
fi
if ! type overcommit > /dev/null 2>&1 ; then
  echo "Install overcommit using: gem install overcommit"
fi

export PATH="${HOME}/.local/bin${PATH:+:${PATH}}"

## fzf
if type fzf > /dev/null 2>&1 ; then
  if ! test -f "${HOME}"/.fzf.bash; then
    "${HOMEBREW_PREFIX}/opt/fzf/install" --all --no-update-rc
  fi
  if test -f "${HOME}"/.fzf.bash; then
      if test $(uname -n) != firefly.local > /dev/null 2>&1; then
        source "${HOME}"/.fzf.bash
      else
        echo Check if fzf is working!!!
      fi
  fi
else
    echo "Install fzf using: brew install fzf"
fi

case $(uname -s) in
    "Linux" )
        function cleanup {
          echo "Killing SSH-Agent"

          rm -rf $(ls -ld /tmp/ssh-* | grep fodonovan | awk '{print $9}') > /dev/null 2>&1
          kill -9 $SSH_AGENT_PID > /dev/null 2>&1
        }
        # 2016-05-31 - commented below to debug sudden exits
        # trap cleanup EXIT

        # https://github.com/KittyKatt/screenFetch
        if type screenfetch > /dev/null 2>&1 ; then
          screenfetch
        fi
        ;;
    "Darwin" )
        # https://github.com/obihann/archey-osx
        if type archey > /dev/null 2>&1 ; then
          archey
        else
          echo "Install archey using: brew install archey4"
        fi

        # Add tab completion for `defaults read|write NSGlobalDomain`
        # You could just use `-g` instead, but I like being explicit
        complete -W "NSGlobalDomain" defaults;

        # homebrew openssh with keychain support doesn't work anymore?
        # Below use Apple's ssh-add, rather than brew ssh-add
        # Move to interactive-only part
        # No need to launch ssh-agent - should be done by default
        # /usr/bin/ssh-add -l &> /dev/null || /usr/bin/ssh-add -K # ~/.ssh/id_rsa

        # Add `killall` tab completion for common apps
        complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

        # Disable per-session command history feature in El Capitan
        # <https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan>
        export SHELL_SESSION_HISTORY=0
      ;;
esac

# Add keychain keys - use 1password instead for ssh key
if type keychain > /dev/null 2>&1; then
    eval "$(keychain --eval --agents gpg --ignore-missing --inherit any 6519D396 740CFB25 9DE94ABA )"
else
    echo "Install keychain using: brew install keychain"
fi

# # Add 1password-cli session
if type op > /dev/null 2>&1; then
    eval "$(op signin --account slesnonovans)"
else
    echo "Install 1password-cli using: brew cask install 1password-cli"
fi

# Use `/bin/ls` for these tests, since homebrew `ls` gives errors
if /bin/ls "${HOME}"/.bash/* 1> /dev/null 2>&1; then
  for file in "${HOME}"/.bash/*; do
    source $file
  done;
  unset file;
fi

# source .bash_aliases and .bash_aliases.local.<blah>
if /bin/ls "${HOME}"/.bash_aliases* 1> /dev/null 2>&1; then
  for file in "${HOME}"/.bash_aliases*; do
    source "${file}"
  done;
  unset file;
fi

# A utility for sending notifications, on demand and when commands finish.
# https://github.com/dschep/ntfy/
if type ntfy > /dev/null 2>&1; then
  eval "$(ntfy shell-integration --foreground-too)"
  export AUTO_NTFY_DONE_IGNORE="aws-shell ec emacs glances ipython jupyter man meld "\
"psql screen tmux vim"
fi

### https://github.com/chrisallenlane/cheat
### cheat allows you to create and view interactive cheatsheets on the command-line.
export CHEATCOLORS=true

### https://github.com/clvv/fasd
### Offers quick access to files and directories
if type fasd > /dev/null 2>&1 ; then
  eval "$(fasd --init auto)"
else
  echo "Install fasd using: brew install fasd"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# "Magnificent app which corrects your previous console command"
if type thefuck > /dev/null 2>&1; then
  eval "$(thefuck --alias)"
else
  echo "Install thefuck using: brew install thefuck"
fi

# pyenv
if type pyenv > /dev/null 2>&1; then
  eval "$(pyenv init --path)"  # Puts shims dir as prefix to PATH.
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
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
if type starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
else
  echo "Install starship using: brew install starship"
fi

### http://direnv.net/
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
else
  echo "Install direnv using: brew install direnv"
fi

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if test -f "${HOME}"/.bashhub/bashhub.sh > /dev/null 2>&1; then
  source "${HOME}"/.bashhub/bashhub.sh
fi

if test -f "${HOME}"/.config/broot/launcher/bash/br > /dev/null 2>&1; then
  source "${HOME}"/.config/broot/launcher/bash/br
fi

# To enable support via ssh-add.
export SSH_AUTH_SOCK=~/.1password/agent.sock

# nbp bash completion
if type nbp > /dev/null 2>&1; then
  if ! test -f "${HOME}"/.bash_completions/nbp.sh > /dev/null 2>&1; then
    nbp --install-completion bash
  fi
  if test -f "${HOME}"/.bash_completions/nbp.sh > /dev/null 2>&1; then
    source "${HOME}"/.bash_completions/nbp.sh
  fi
else
  echo "Install nbp using: pipx install nbpreview"
fi

# Deduplicate PATH variable
export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"

### Print message of the day.

# istheinternetonfire.com
if ping -c 1 google.com > /dev/null 2>&1 ; then
    echo "Is the internet on fire?:"
    dig +short -t txt istheinternetonfire.com
fi

# pyjokes
if type pyjoke > /dev/null 2>&1; then
  echo
  echo "Joke of the Day:"
  pyjoke
fi

# tldr

if type tldr > /dev/null 2>&1; then
    echo
    echo "tldr random example"
    tldr --random-example
fi

# motd
if type motd > /dev/null 2>&1; then
    echo
    echo "message of the day"
    motd
fi
