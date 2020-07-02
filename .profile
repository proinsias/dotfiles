# User dependent .profile file - Non-interactive, login-shell stuff goes in here
# Stuff NOT specifically related to `bash`, such as environment variables (`PATH` and
# friends) – Anything that should be available to graphical applications OR to sh or
# to login shells

# set PATH so it includes user's private bin if it exists
if [ -d "${HOME}/bin" ] ; then
    export PATH="${PATH:+${PATH}:}${HOME}/bin"
fi

if [ -d "${HOME}/.generic/bin" ] ; then
    export PATH="${PATH:+${PATH}:}${HOME}/.generic/bin"
fi

# for hunspell
export LANG=en_US.UTF-8
export DICTIONARY=en_US

export NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="${NPM_PACKAGES}${PATH:+:${PATH}}"
export MANPATH="${NPM_PACKAGES}/share/man${MANPATH:+:${MANPATH}}"

# Set MANPATH so it includes users' private man if it exists
if test -d "${HOME}/man" > /dev/null 2>&1; then
  MANPATH="${HOME}/man${MANPATH:+:${MANPATH}}"
fi

# Set INFOPATH so it includes users' private info if it exists
if test -d "${HOME}/info" > /dev/null 2>&1; then
  INFOPATH="${HOME}/info${INFOPATH:+:${INFOPATH}}"
fi

# For homebrew
export HOMEBREW_PREFIX="$(brew --prefix)"
export HOMEBREW_INSTALL_CLEANUP=true

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
      if [ -d "${HOME}/.linuxbrew/bin" ] ; then
          export PATH="${PATH:+${PATH}:}${HOME}/.linuxbrew/bin"
      fi
      if [ -d "${HOME}/.linuxbrew/sbin" ] ; then
          export PATH="${PATH:+${PATH}:}${HOME}/.linuxbrew/sbin"
      fi

      # gpg-agent
      export GPG_TTY=$(tty)
      ;;
    "Darwin" )
      # homebrew
      export PATH="${HOMEBREW_PREFIX}/bin:${HOMEBREW_PREFIX}/sbin${PATH:+:${PATH}}"

      if [ -d "${HOME}/.osx/bin" ] ; then
          export PATH="${PATH:+${PATH}:}${HOME}/.osx/bin"
      fi

      # To install homebrew casks in /Applications by default
      export HOMEBREW_CASK_OPTS="--appdir=/Applications"
      ;;
esac

# ruby
export RUBY_HOME="${HOMEBREW_PREFIX}/opt/ruby"
export RUBY_VERSION="2.6.0"
export PATH="${RUBY_HOME}/bin${PATH:+:${PATH}}"
export GEM_HOME="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"
export GEM_PATH="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"

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
if type overcommit > /dev/null 2>&1 ; then
  export GIT_TEMPLATE_DIR="$(overcommit --template-dir)"
fi

# Ccache
export PATH="${HOMEBREW_PREFIX}/opt/ccache/libexec${PATH:+:${PATH}}"

case $(uname -s) in
    "Linux" )
        ;;
    "Darwin" )
        export JAVA_HOME="$(/usr/libexec/java_home)"  # Need Java8 not Java9 for Spark.
        export PATH="${JAVA_HOME}/bin${PATH:+:${PATH}}"

        export SCALA_HOME="${HOMEBREW_PREFIX}/opt/scala/idea"  # To use with IntelliJ.
        ;;
esac

# added by Snowflake SnowSQL installer v1.0
export PATH="/Applications/SnowSQL.app/Contents/MacOS${PATH:+:${PATH}}"

# Go Lang
export GOPATH="${HOME}/golang"
export GOROOT="${HOMEBREW_PREFIX}/opt/go/libexec"
export PATH="${GOPATH}/bin${PATH:+:${PATH}}"
export PATH="${GOROOT}/bin${PATH:+:${PATH}}"

# # Prevent accidental global package install through pip.
# export PIP_REQUIRE_VIRTUALENV=true

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/google-cloud-sdk/path.bash.inc' ]; then
  . '/usr/local/google-cloud-sdk/path.bash.inc'
fi

# If not running interactively, stop here
[[ "$-" != *i* ]] && return
