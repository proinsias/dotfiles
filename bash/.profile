# User dependent .profile file - Non-interactive, login-shell stuff goes in here
# Stuff NOT specifically related to `bash`, such as environment variables (`PATH` and
# friends) – Anything that should be available to graphical applications OR to sh or
# to login shells

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
    export PATH="${HOME}/bin${PATH:+:${PATH}}"
fi

if [ -d "${HOME}/.generic/bin" ] ; then
    export PATH="${PATH:+${PATH}:}${HOME}/.generic/bin"
fi

# for hunspell
export LANG=en_US.UTF-8
export DICTIONARY=en_US

export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="${PATH:+${PATH}:}${NPM_PACKAGES}/bin"
export MANPATH="${NPM_PACKAGES}/share/man${MANPATH:+:${MANPATH}}"

# Set MANPATH so it includes users' private man if it exists
if test -d "${HOME}/man" > /dev/null 2>&1; then
  MANPATH="${HOME}/man${MANPATH:+:${MANPATH}}"
fi

# Set INFOPATH so it includes users' private info if it exists
if test -d "${HOME}/info" > /dev/null 2>&1; then
  INFOPATH="${HOME}/info${INFOPATH:+:${INFOPATH}}"
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

      if [ -d "${HOME}/.ubuntu/bin" ] ; then
          export PATH="${PATH:+${PATH}:}${HOME}/.ubuntu/bin"
      fi

      # homebrew linuxbrew
      test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      test -d "${HOME}/.linuxbrew/" && eval "$(${HOME}/.linuxbrew/bin/brew shellenv)"

      # gpg-agent
      export GPG_TTY=$(tty)

      export PATH="/usr/lib/ccache${PATH:+:${PATH}}"
      ;;
    "Darwin" )
      # Intel homebrew
      test -f /usr/local/bin/brew && eval "$(/usr/local/bin/brew shellenv)"
      test -d /usr/local/lib && export LDFLAGS="-L/usr/local/lib ${LDFLAGS}"
      test -d /usr/local/include && export CPPFLAGS="-L/usr/local/include ${CPPFLAGS}"
      # M1 home-brew – do second in case we are also using Intel
      # via Rosetta.
      test -f /opt/homebrew/bin/brew && eval "$(/opt/homebrew/bin/brew shellenv)"
      test -d /opt/homebrew/lib && export LDFLAGS="-L/opt/homebrew/lib ${LDFLAGS}"
      test -d /opt/homebrew/include && export CPPFLAGS="-L/opt/homebrew/include ${CPPFLAGS}"

      if [ -d "${HOME}/.osx/bin" ] ; then
          export PATH="${PATH:+${PATH}:}${HOME}/.osx/bin"
      fi

      # To install homebrew casks in /Applications by default
      export HOMEBREW_CASK_OPTS="--appdir=/Applications"

      ;;
esac

# For homebrew
export HOMEBREW_INSTALL_CLEANUP=true

# ruby
export RUBY_HOME="${HOMEBREW_PREFIX}/opt/ruby"
export RUBY_VERSION="3.1.0"
export PATH="${RUBY_HOME}/bin${PATH:+:${PATH}}"
export GEM_HOME="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"
export GEM_PATH="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"
export PATH="${PATH:+${PATH}:}${GEM_PATH}/bin"

# Add homebrew's GNU coreutils (ls, cat, etc.) to PATH, etc. - see
#http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
# May cause issues - e.g., archey doesn't work with 'gawk'
#export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin${PATH:+:${PATH}}"
export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman${MANPATH:+:${MANPATH}}"

# Add homebrew's GNU findutils to PATH:
#export PATH="${HOMEBREW_PREFIX}/opt/findutils/bin${PATH:+:${PATH}}"
export MANPATH="${HOMEBREW_PREFIX}/opt/findutils/share/man${MANPATH:+:${MANPATH}}"

export MANPATH="${HOMEBREW_PREFIX}/share/man${MANPATH:+:${MANPATH}}"
export INFOPATH="${HOMEBREW_PREFIX}/share/info${INFOPATH:+:${INFOPATH}}"

# For hunspell
export DICPATH="${HOME}/.hunspell_default:${HOMEBREW_PREFIX}/share/hunspell${DICPATH:+:${DICPATH}}"

# Wrap git automatically with hub
if type hub > /dev/null 2>&1 ; then
  eval "$(hub alias -s)"
fi

# overcommit
#if type overcommit > /dev/null 2>&1 ; then
#  export GIT_TEMPLATE_DIR="$(overcommit --template-dir)"
#fi

export GIT_TEMPLATE_DIR="${HOME}"/.git-template

# Ccache
export PATH="${HOMEBREW_PREFIX}/opt/ccache/libexec${PATH:+:${PATH}}"

case $(uname -s) in
    "Linux" )
        ;;
    "Darwin" )
        export JAVA_HOME="$(/usr/libexec/java_home)"  # Need Java8 not Java9 for Spark.
        export PATH="${PATH:+${PATH}:}${JAVA_HOME}/bin"

        export SCALA_HOME="${HOMEBREW_PREFIX}/opt/scala/idea"  # To use with IntelliJ.
        ;;
esac

# Go Lang
export GOPATH="${HOME}/golang"
export GOROOT="${HOMEBREW_PREFIX}/opt/go/libexec"
export PATH="${PATH:+${PATH}:}${GOPATH}/bin"
export PATH="${PATH:+${PATH}:}${GOROOT}/bin"

# # Prevent accidental global package install through pip.
# export PIP_REQUIRE_VIRTUALENV=true

# Ensure pipenv creates its own virtual environments for projects.
export PIPENV_IGNORE_VIRTUALENVS=1

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.bash.inc' ]; then
  . '/usr/local/google-cloud-sdk/path.bash.inc'
fi

export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:${PATH}"
eval "$(pyenv init --path)"  # Puts shims dir as prefix to PATH.

# If not running interactively, stop here
[[ "$-" != *i* ]] && return
