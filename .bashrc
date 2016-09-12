# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# source .bashrc.local and .bashrc.local.<blah>
if /bin/ls ~/.bashrc.local* 1> /dev/null 2>&1; then
  for file in ~/.bashrc.local*; do
    source "${file}"
  done;
  unset file;
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

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

# https://github.com/git/git/blob/master/contrib/completion/git-completion.bash
if [ -f ~/.bash/git-completion.sh ]; then
    source ~/.bash/git-completion.sh
fi

# `npm completion > ~/.bash/npm-completion.bash`
if [ -f ~/.bash/npm-completion.sh ]; then
    source ~/.bash/npm-completion.sh
fi

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
#done;
#unset file;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

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
  echo "brew tap homebrew/command-not-found"
fi

### wakatime
if wakatime -h > /dev/null 2>&1 ; then
  source ~/bin/bash-wakatime.sh
else
  echo "Please install wakatime command:"
  echo "$ pip install wakatime"
fi

### tab completion for conda
if conda -V > /dev/null 2>&1 ; then
  eval "$(register-python-argcomplete conda)"
fi

## fzf
if fzf -h > /dev/null 2>&1 ; then
  [ -f ~/.fzf.bash ] && source ~/.fzf.bash
else
  echo "Please install fzf command:"
  echo "$ brew install fzf"
fi

if activate-global-python-argcomplete -h > /dev/null 2>&1 ; then
  # Global tab completion for argcomplete-supported apps
  if [ ! -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete.sh" ]; then
    activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
  fi
else
  echo "Please install activate-global-python-argcomplete command:"
  echo "pip/conda install argcomplete"
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

        # Disable per-session command history feature in El Capitan
        # <https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan>
        export SHELL_SESSION_HISTORY=0
      ;;
esac




# AWS bash completion
complete -C aws_completer aws

# Add keychain keys
eval $(keychain --eval --agents ssh,gpg --inherit any id_rsa D2E0BEAC 97FAE23F)

### motd
echo "Don't forget to use fzf, fasd, cheat and bashhub!"

# Use `/bin/ls` for these tests, since homebrew `ls` gives errors
if /bin/ls ~/.bash/* 1> /dev/null 2>&1; then
  for file in ~/.bash/*; do
    source $file
  done;
  unset file;
fi

# source .bash_aliases and .bash_aliases.local.<blah>
if /bin/ls ~/.bash_aliases* 1> /dev/null 2>&1; then
  for file in ~/.bash_aliases*; do
    source "${file}"
  done;
  unset file;
fi

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if [ -f ~/.bashhub/bashhub.sh ]; then
    source ~/.bashhub/bashhub.sh
fi

