# Non-interactive stuff here

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# Use `/bin/ls` for these tests, since homebrew `ls` gives errors
if /bin/ls ~/.bash/* 1> /dev/null 2>&1; then
  for file in ~/.bash/*; do
    source $file
  done
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

export PATH="${PATH}:${HOME}/scripts"

# for hunspell
export LANG=en_US.UTF-8
export DICTIONARY=en_US

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="${NPM_PACKAGES}/bin:${PATH}"
export MANPATH="${NPM_PACKAGES}/share/man:${MANPATH}"

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027 # messes up is2
# Paranoid: neither group nor others have any perms:
# umask 077

case $(uname -s) in
    "Linux" )
      ## set environment variables if user's agent already exists
      ### Need to try again when system ssh-agent has been rebooted
      ##[ -z "$SSH_AUTH_SOCK" ] && SSH_AUTH_SOCK=$(ls -l /tmp/ssh-*/agent.* 2> /dev/null | grep $(whoami) | awk '{print $9}')
      #SSH_AUTH_SOCK=$(ls -l /tmp/ssh-*/agent.* 2> /dev/null | grep $(whoami) | awk '{print $9}')
      #
      #[ -z "$SSH_AGENT_PID" -a -n "$(echo $SSH_AUTH_SOCK | cut -d. -f2)" ] && SSH_AGENT_PID=$(($(echo $SSH_AUTH_SOCK | cut -d. -f2 | cut -d= -f1) + 1))
      #[ -n "$SSH_AUTH_SOCK" ] && export SSH_AUTH_SOCK
      #[ -n "$SSH_AGENT_PID" ] && export SSH_AGENT_PID

      # start agent if necessary
      #if [ -z $SSH_AGENT_PID ] && [ -z $SSH_TTY ]; then  # if no agent & not in ssh
      #if [ -z $SSH_AGENT_PID ] ; then
      #   eval $(ssh-agent -s)
      #fi

      # homebrew linuxbrew
      export PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"

      # gpg-agent
      export GPG_TTY=$(tty)
      ;;
    "Darwin" )
      # homebrew - shouldn't be necessary on mac
      # export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

      # To install homebrew casks in /Applications by default
      export HOMEBREW_CASK_OPTS="--appdir=/Applications"
      ;;
esac

# For homebrew
export HOMEBREW_PREFIX="$(brew --prefix)"

# ruby
export RBENV_ROOT="$(brew --prefix rbenv)"
export GEM_HOME="${HOMEBREW_PREFIX}/opt/gems"
export GEM_PATH="${HOMEBREW_PREFIX}/opt/gems"
export PATH="$GEM_HOME/bin:$PATH"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# Add homebrew's GNU coreutils (ls, cat, etc.) to PATH, etc. - see
#http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:$MANPATH"

export MANPATH="${HOMEBREW_PREFIX}/share/man:$MANPATH"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:$INFOPATH"

# source local files and aliases

# source .bashrc.local and .bashrc.local.<blah>
if /bin/ls ~/.bashrc.local* 1> /dev/null 2>&1; then
  for file in ~/.bashrc.local*; do
    source "${file}"
  done
fi

# source .bash_aliases and .bash_aliases.local.<blah>
if /bin/ls ~/.bash_aliases* 1> /dev/null 2>&1; then
  for file in ~/.bash_aliases*; do
    source "${file}"
  done
fi

# Mix of interactivity here

# Wrap git automatically
if type hub > /dev/null 2>&1 ; then
  eval "$(hub alias -s)"
else
  # Test for interactive shell
  [[ "$-" == *i* ]] && echo "Please install hub command"
fi

# overcommit
# https://github.com/nvbn/thefuck/
if type overcommit > /dev/null 2>&1 ; then
  export GIT_TEMPLATE_DIR=$(overcommit --template-dir)
else
  [[ "$-" == *i* ]] && echo "Please install overcommit command"
fi

# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
set -o ignoreeof
#
# Use case-insensitive filename globbing
shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
shopt -s cdspell

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
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options
#
# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
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

export EDITOR='emacs -nw'
if [[ -n "${EDITOR}" && -z "${VISUAL}" ]] ; then
  export VISUAL="${EDITOR}"
fi

export GIT_EDITOR=emacs

RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"
WHITE="\[\033[1;37m\]"
PS1="$GREEN\u@\h $YELLOW\w $RED\$(parse_git_branch)$WHITE [\!]\n\$ "

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
#for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
#    [ -r "$file" ] && [ -f "$file" ] && source "$file";
#    done;
#    unset file;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# istheinternetonfire.com
if ping -c 1 google.com > /dev/null 2>&1 ; then
    echo "Is the internet on fire?:"
    dig +short -t txt istheinternetonfire.com
else
  echo "No internet connectivity..."
fi

# for autojump
[[ -s "${HOMEBREW_PREFIX}/etc/autojump.sh" ]] && . "${HOMEBREW_PREFIX}/etc/autojump.sh"

# For homebrew bash completion
if [ -f "${HOMEBREW_PREFIX}/etc/bash_completion" ]; then
    . "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

if brew command command-not-found-init > /dev/null; then
  eval "$(brew command-not-found-init)";
else
  echo "Please install command-not-found-init command:"
fi

### wakatime
if wakatime -h > /dev/null 2>&1 ; then
  source ~/scripts/bash-wakatime.sh
else
  echo "Please install wakatime command:"
  echo "$ pip install wakatime"
fi

### tab completion for conda
if conda -V > /dev/null 2>&1 ; then
  eval "$(register-python-argcomplete conda)"
fi

### fzf
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

### Global tab completion for argcomplete-supported apps
if [ ! -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete.sh" ]; then
  activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
fi

case $(uname -s) in
    "Linux" )
        # https://github.com/KittyKatt/screenFetch
        if type screenfetch > /dev/null 2>&1 ; then
          screenfetch
        else
          echo "Please install screenfetch command"
        fi

        function cleanup {
          echo "Killing SSH-Agent"

          rm -rf $(ls -ld /tmp/ssh-* | grep fodonovan | awk '{print $9}') > /dev/null 2>&1
          kill -9 $SSH_AGENT_PID > /dev/null 2>&1
        }
	# 2016-05-31 - commented below to debug sudden exits
        # trap cleanup EXIT
        ;;
    "Darwin" )
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

        # https://github.com/obihann/archey-osx
        if type archey > /dev/null 2>&1 ; then
          archey -p
        else
          echo "Please install archey command"
        fi

        # Disable per-session command history feature in El Capitan
        # <https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan>
        export SHELL_SESSION_HISTORY=0
      ;;
esac

### motd
echo "Don't forget to use fzf, fasd and bashhub!"

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if [ -f ~/.bashhub/bashhub.sh ]; then
    source ~/.bashhub/bashhub.sh
fi


