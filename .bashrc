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

# Create venv directory in case doesn't exist.
mkdir -p "${HOME}"/.virtualenvs

### travis
#if ! travis -h > /dev/null 2>&1 ; then
#  echo Installing travis...
#  gem install travis
#fi
#if test -f ~/.travis/travis.sh > /dev/null 2>&1; then
#  source ~/.travis/travis.sh
#fi

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
# Include filenames beginning with ‘.’ in results of filename expansion
shopt -s dotglob
#
# ‘**’ used in filename expansion context will match all files and zero or
# more directories and subdirectories. If pattern is followed by ‘/’, only directories
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

eval "$(pipenv --completion)"

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
export ALTERNATE_EDITOR=""

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

## pipx
if ! pipx -h > /dev/null 2>&1 ; then
  echo Installing pipx...
  brew install pipx
fi

# added by pipx (https://github.com/pipxproject/pipx)
export PATH="${HOME}/.local/bin${PATH:+:${PATH}}"

## em
if ! em -h > /dev/null 2>&1 ; then
  echo Installing em...
  pipx install em-keyboard --python /usr/local/bin/python3
fi

## safety
if ! safety --help > /dev/null 2>&1 ; then
  echo Installing safety...
  pipx install safety --python /usr/local/bin/python3
fi

## pyjokes
if ! pyjoke -h > /dev/null 2>&1 ; then
  echo Installing pyjoke...
  pipx install pyjokes --python /usr/local/bin/python3
fi

## clf
if ! clf -h > /dev/null 2>&1 ; then
  echo Installing clf...
  pipx install clf --python /usr/local/bin/python3
fi

## howdoi
if ! howdoi -h > /dev/null 2>&1 ; then
  echo Installing howdoi...
  brew install howdoi
fi

## tldr
if ! tldr -h > /dev/null 2>&1 ; then
  echo Installing tldr...
  pipx install tldr --python /usr/local/bin/python3
fi

## eg
if ! eg -h > /dev/null 2>&1 ; then
  echo Installing eg...
  brew install eg-examples
fi

## how2
if ! how2 -h > /dev/null 2>&1 ; then
  echo Installing how2...
  npm install --global how-2
fi

## uncommitted
if ! uncommitted -h > /dev/null 2>&1 ; then
  echo Installing uncommitted...
  pipx install uncommitted --python /usr/local/bin/python3
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

# Add keychain keys
eval $(keychain --eval --agents ssh,gpg --inherit any id_rsa D2E0BEAC,6519D396,9DE94ABA,9879E8CA --ignore-missing)

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

## argcomplete
if ! activate-global-python-argcomplete -h > /dev/null 2>&1 ; then
  echo Installing argcomplete...
  pipx install argcomplete --python /usr/local/bin/python3
fi

### tab completion for conda
if conda -V > /dev/null 2>&1 ; then
  eval "$(register-python-argcomplete conda)"
fi

# Global tab completion for argcomplete-supported apps
if ! test -f "${HOMEBREW_PREFIX}/etc/bash_completion.d/python-argcomplete.sh"; then
  activate-global-python-argcomplete --dest "${HOMEBREW_PREFIX}/etc/bash_completion.d"
fi

# A utility for sending notifications, on demand and when commands finish.
# https://github.com/dschep/ntfy/
if ! type ntfy > /dev/null 2>&1; then
    if test $(uname -n) != firefly.local > /dev/null 2>&1; then
      echo Installing ntfy...
      pipx install ntfy[pid,emoji,slack] --python /usr/local/bin/python3
    else
      echo Check if ntfy installation works!!!
    fi
fi
 if type ntfy > /dev/null 2>&1; then
  eval "$(ntfy shell-integration --foreground-too)"
  export AUTO_NTFY_DONE_IGNORE="aws-shell ec emacs glances ipython jupyter man meld "\
"psql screen tmux vim"
fi

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
if type fasd > /dev/null 2>&1 ; then
  eval "$(fasd --init auto)"
fi

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# "Magnificent app which corrects your previous console command"
eval $(thefuck --alias)

# FIXME: To fix.
# Only load Liquid Prompt in interactive shells, not from a script or from scp
# [[ $- = *i* ]] && source ~/Documents/GitHub/liquidprompt/liquidprompt

# p4merge
export PATH="/Applications/p4merge.app/Contents//MacOS${PATH:+:${PATH}}"

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
fi

# ssh-add -A  # Add all identities stored in your keychain.
ssh-add ~/.ssh/id_rsa
# To add identities, run:
# ssh-add -K ~/.ssh/id_rsa

if test $(hostname -s) == 'ospideal'; then
    # The next line enables shell command completion for gcloud.
    if [ -f '/usr/local/google-cloud-sdk/completion.bash.inc' ]; then
      	. '/usr/local/google-cloud-sdk/completion.bash.inc'
    fi
fi

### Bashhub.com Installation.
### This Should be at the EOF. https://bashhub.com/docs
if ! test -f ~/.bashhub/bashhub.sh > /dev/null 2>&1; then
  echo Installing bashhub...
  cd /tmp/ && curl --location --remote-name https://bashhub.com/setup && PIP_REQUIRE_VIRTUALENV="" bash setup && cd -
fi
if test -f ~/.bashhub/bashhub.sh > /dev/null 2>&1; then
  source ~/.bashhub/bashhub.sh
fi

### motd
echo "* bash"
echo "  + `!?foo` will repeat the most recent command that contained the string 'foo'"
echo "* em – emojii"
echo "* Search help for command line"
echo "  + clf, eg, howdoi, how2, tldr"
echo "* f@@k - https://github.com/nvbn/thef@@k"
echo "* bashhub - https://bashhub.com/"
echo '  + bh -n 20 "grep"  # last 20 files greped'
echo '  + bh -i "wget github"  # interactive search to execute command again'
echo '  + bh -d  # last command executed in current directory'
echo '  + bh -sys -n 10 "curl"  # last 10 curl commands on this system'
echo "  + bashhub status  # summary of user stats/status"
echo "  + bashhub off/on  # turn bashhub recording off/on"
echo '  + echo this command will no be saved #ignore  # bashhub will ignore this command'
echo "* cheat - https://github.com/chrisallenlane/cheat"
echo "  + cheat tar"
echo "* fasd - https://github.com/clvv/fasd"
echo "  + f foo           # list frecent files matching foo"
echo "  + a foo bar       # list frecent files and directories matching foo and bar"
echo "  + f js$           # list frecent files that ends in js"
echo "  + f -e vim foo    # run vim on the most frecent file matching foo"
echo "  + mplayer \`f bar\` # run mplayer on the most frecent file matching bar"
echo "  + z foo           # cd into the most frecent directory matching foo"
echo "  + open \`sf pdf\`   # interactively select a file matching pdf and launch open"
echo "* fzf - https://github.com/junegunn/fzf"
echo "  + Figure out fasd first"
echo "* tig - https://jonas.github.io/tig/"
echo "  + git show | tig"
echo "  + tig show"
echo "* httpie - https://httpie.org/doc#main-features"
echo "* git branch-status"
echo "* dvc status"

# pyjokes
echo
echo "Joke of the Day:"
pyjoke

