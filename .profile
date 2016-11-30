# User dependent .profile file - Non-interactive, login-shell stuff goes in here
# Stuff NOT specifically related to `bash`, such as environment variables (`PATH` and
# friends) – Anything that should be available to graphical applications OR to sh or
# to login shells

# Add my personal bin directory to the PATH
export PATH="${PATH}:${HOME}/bin"
export PATH="${PATH}:${HOME}/.generic/bin"

# for hunspell
export LANG=en_US.UTF-8
export DICTIONARY=en_US

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="${NPM_PACKAGES}/bin:${PATH}"
export MANPATH="${NPM_PACKAGES}/share/man:${MANPATH}"

# Set MANPATH so it includes users' private man if it exists
if test -d "${HOME}/man"; then
  MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if test -d "${HOME}/info"; then
  INFOPATH="${HOME}/info:${INFOPATH}"
fi

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

      export PATH="${PATH}:${HOME}/.ubuntu/bin"

      # homebrew linuxbrew
      export PATH="${HOME}/.linuxbrew/bin:${HOME}/.linuxbrew/sbin:${PATH}"

      # gpg-agent
      export GPG_TTY=$(tty)
      ;;
    "Darwin" )
      # homebrew
      export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

      export PATH="${PATH}:${HOME}/.osx/bin"

      # To install homebrew casks in /Applications by default
      export HOMEBREW_CASK_OPTS="--appdir=/Applications"
      ;;
esac

# For homebrew
export HOMEBREW_PREFIX="$(brew --prefix)"

# ruby
if ! type rbenv > /dev/null; then
  [[ "$-" == *i* ]] && echo Installing rbenv...
  brew install rbenv
fi

if type rbenv > /dev/null; then
  eval "$(rbenv init -)";
fi

### http://www.jenv.be/
export PATH="$HOME/.jenv/bin:$PATH"
if ! type jenv > /dev/null; then
  echo Installing jenv...
  brew install jenv
fi
#if type jenv > /dev/null; then
#  eval "$(jenv init -)";
#fi

### https://github.com/yyuu/pyenv
### https://github.com/yyuu/pyenv-virtualenv
if ! type pyenv > /dev/null; then
  echo Installing pyenv...
  brew install pyenv
fi
if type pyenv > /dev/null; then
  eval "$(pyenv init -)";
fi

if ! type pyenv-virtualenv-init > /dev/null; then
  echo Installing pyenv-virtualenv...
  brew install pyenv-virtualenv
fi
if type pyenv-virtualenv-init > /dev/null; then
  eval "$(pyenv virtualenv-init -)";
fi

# Add homebrew's GNU coreutils (ls, cat, etc.) to PATH, etc. - see
#http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
# May cause issues - e.g., archey doesn't work with 'gawk'
#export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin:${PATH}"
export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:${MANPATH}"

export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH}"
export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH}"

# For hunspell
export DICPATH="${HOME}/.hunspell_default:/usr/local/share/hunspell:${DICPATH}"

# Mix of interactivity here

# Wrap git automatically with hub
if ! type hub > /dev/null 2>&1 ; then
  [[ "$-" == *i* ]] && echo Installing hub...
  brew install hub
fi
if type hub > /dev/null 2>&1 ; then
  eval "$(hub alias -s)"
fi

# overcommit
if ! type overcommit > /dev/null 2>&1 ; then
  [[ "$-" == *i* ]] && echo Installing overcommit...
  gem install overcommit
fi
if type overcommit > /dev/null 2>&1 ; then
  export GIT_TEMPLATE_DIR=$(overcommit --template-dir)
fi

# If not running interactively, stop here
[[ "$-" != *i* ]] && return

# istheinternetonfire.com
if ping -c 1 google.com > /dev/null 2>&1 ; then
    echo "Is the internet on fire?:"
    dig +short -t txt istheinternetonfire.com
else
  echo "No internet connectivity..."
fi

case $(uname -s) in
    "Linux" )
        # https://github.com/KittyKatt/screenFetch
        if ! type screenfetch > /dev/null 2>&1 ; then
            echo Installing screenfetch...
            brew install screenfetch
        fi
        if type screenfetch > /dev/null 2>&1 ; then
          screenfetch
        fi
        ;;
    "Darwin" )
        # https://github.com/obihann/archey-osx
        if ! type archey > /dev/null 2>&1 ; then
          echo Installing archey...
          brew install archey
        fi
        if type archey > /dev/null 2>&1 ; then
          archey -p
        fi

        export JAVA_HOME="$(/usr/libexec/java_home)"
        ;;
esac
