# User dependent .bashrc file
# Anything you'd want at an interactive non-login shell. Command prompt, `EDITOR`
# variable, bash aliases for my use.
# only output stuff in interactive mode.

# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# Source global definitions
if test -f /etc/bashrc ; then
        . /etc/bashrc

# added by travis gem
if ! test -f ~/.travis/travis.sh > /dev/null 2>&1; then
    echo Installing travis...
    gem install travis
    echo Run travis command to install auto-completion!!!
fi
if test -f ~/.travis/travis.sh > /dev/null 2>&1; then
  source ~/.travis/travis.sh
fi

# source .bashrc.local and .bashrc.local.<blah>
if /bin/ls ~/.bashrc.local* 1> /dev/null 2>&1; then
  for file in ~/.bashrc.local*; do
    source "${file}"
  done;
  unset file;
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

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

if ! test -f ~/bin/git-completion.sh > /dev/null 2>&1; then
    echo Installing git completion...
    wget \
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash \
--output-document=~/bin/git-completion.sh
fi
if test -f ~/bin/git-completion.sh > /dev/null 2>&1; then
    source ~/bin/git-completion.sh
fi

if ! test -f ~/bin/npm-completion.sh > /dev/null 2>&1; then
    echo Installing npm compleition...
    npm completion > ~/bin/npm-completion.sh
fi
if test -f ~/bin/npm-completion.sh > /dev/null 2>&1; then
    source ~/bin/npm-completion.sh
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

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X";

export EDITOR='emacsclient'
if [[ -n "${EDITOR}" && -z "${VISUAL}" ]] ; then
  export VISUAL="${EDITOR}"
fi

export GIT_EDITOR=emacsclient

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

# For homebrew bash completion
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion" > /dev/null 2>&1; then
  echo Installing bash completion...
  brew install 'homebrew/completions/bash-completion'
fi
if test -f "${HOMEBREW_PREFIX}/etc/bash_completion" > /dev/null 2>&1; then
    . "${HOMEBREW_PREFIX}/etc/bash_completion"
fi

if ! brew command command-not-found-init > /dev/null 2>&1; then
  echo Installing command-not-found-init...
  brew tap homebrew/command-not-found
fi
if brew command command-not-found-init > /dev/null 2>&1; then
  eval "$(brew command-not-found-init)";
fi

## fzf
if ! fzf -h > /dev/null 2>&1 ; then
  echo Installing fzf...
  brew install fzf
fi
if fzf -h > /dev/null 2>&1 ; then
  if ! test -f ~/.fzf.bash; then
    "${HOMEBREW_PREFIX}/opt/fzf/install" --all --no-update-rc
  fi
  if test -f ~/.fzf.bash; then
      if test $(uname -n) != firefly.local > /dev/null 2>&1; then
	  source ~/.fzf.bash
      else
	  echo Check if fzf is working!!!
      fi
  fi
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

if test $(uname -n) = firefly.local > /dev/null 2>&1; then
    # Add keychain keys
    echo Check if gpg is working!!!
    eval $(keychain --eval --agents ssh --inherit any id_rsa --ignore-missing)
else
    # Add keychain keys
    eval $(keychain --eval --agents ssh,gpg --inherit any id_rsa D2E0BEAC 97FAE23F --ignore-missing)
fi

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

### wakatime
if ! wakatime -h > /dev/null 2>&1 ; then
  brew install wakatime
fi
if wakatime -h > /dev/null 2>&1 ; then
  if ! test -f ~/bin/bash-wakatime.sh > /dev/null 2>&1; then
    wget \
https://raw.githubusercontent.com/irondoge/bash-wakatime/master/bash-wakatime.sh \
--output-document=~/bin/bash-wakatime.sh
  fi
  if test -f ~/bin/bash-wakatime.sh > /dev/null 2>&1; then
    if test $(uname -n) != firefly.local > /dev/null 2>&1; then
	source ~/bin/bash-wakatime.sh
    else
        echo Check if wakatime installation works!!!
    fi
  fi
fi

## argcomplete
if ! activate-global-python-argcomplete -h > /dev/null 2>&1 ; then
  echo Installing argcomplete...
  PYENV_VERSION=system pip install argcomplete
fi

### tab completion for conda
if conda -V > /dev/null 2>&1 ; then
  eval "$(register-python-argcomplete conda)"
fi

# Global tab completion for argcomplete-supported apps
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete.sh"; then
  activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
fi

### A utility for sending notifications, on demand and when commands finish.
### https://github.com/dschep/ntfy/
if ! type ntfy > /dev/null 2>&1; then
    if test $(uname -n) != firefly.local > /dev/null 2>&1; then
	echo Installing ntfy...
	PYENV_VERSION=system pip install ntfy
    else
        echo Check if ntfy installation works!!!
    fi
fi
#if type ntfy > /dev/null 2>&1; then
#  eval "$(ntfy shell-integration --foreground-too)"
#  export AUTO_NTFY_DONE_IGNORE="aws-shell ec emacs glances ipython jupyter man meld "\
#"psql screen tmux vim"
#fi

### http://direnv.net/
if ! type direnv > /dev/null 2>&1; then
  echo Installing direnv...
  brew install direnv
fi
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

### https://github.com/chrisallenlane/cheat
### cheat allows you to create and view interactive cheatsheets on the command-line.
export CHEATCOLORS=true

### https://github.com/clvv/fasd
### Offers quick access to files and directories
if ! type fasd > /dev/null 2>&1; then
  echo Installing fasd...
  brew install fasd
fi
#if type fasd > /dev/null 2>&1 ; then
#  eval "$(fasd --init auto)"
#fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if ! test -f ~/.bashhub/bashhub.sh > /dev/null 2>&1; then
  echo Installing bashhub...
  cd /tmp/ && curl -OL https://bashhub.com/setup && bash setup && cd -
fi
if test -f ~/.bashhub/bashhub.sh > /dev/null 2>&1; then
  source ~/.bashhub/bashhub.sh
fi

### motd
echo "* bashhub"
echo '  + bh -n 20 "grep"  # last 20 files greped'
echo '  + bh -i "wget github"  # interactive search to execute command again'
echo '  + bh -d  # last command executed in current directory'
echo '  + bh -sys -n 10 "curl"  # last 10 curl commands on this system'
echo "  + bashhub status  # summary of user stats/status"
echo "  + bashhub off/on  # turn bashhub recording off/on"
echo '  + echo this command will no be saved #ignore  # bashhub will ignore this command'
echo "* cheat"
echo "  + cheat tar"
echo "* fasd"
echo "  + f foo           # list frecent files matching foo"
echo "  + a foo bar       # list frecent files and directories matching foo and bar"
echo "  + f js$           # list frecent files that ends in js"
echo "  + f -e vim foo    # run vim on the most frecent file matching foo"
echo "  + mplayer \`f bar\` # run mplayer on the most frecent file matching bar"
echo "  + z foo           # cd into the most frecent directory matching foo"
echo "  + open \`sf pdf\`   # interactively select a file matching pdf and launch open"
echo "* fzf"
echo "  + Figure out fasd first"

# added by travis gem
[ -f /Users/francis/.travis/travis.sh ] && source /Users/francis/.travis/travis.sh
