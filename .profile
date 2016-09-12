# User dependent .profile file - Non-interactive, login-shell stuff goes in here

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
if [ -d "${HOME}/man" ]; then
  MANPATH="${HOME}/man:${MANPATH}"
fi

# Set INFOPATH so it includes users' private info if it exists
if [ -d "${HOME}/info" ]; then
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
      # homebrew - shouldn't be necessary on mac
      # export PATH="/usr/local/bin:/usr/local/sbin:${PATH}"

      export PATH="${PATH}:${HOME}/.osx/bin"

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
export PATH="${GEM_HOME}/bin:${PATH}"
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

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
if type hub > /dev/null 2>&1 ; then
  eval "$(hub alias -s)"
else
  # Test for interactive shell
  [[ "$-" == *i* ]] && echo "Please install hub command:\nbrew install hub"
fi

# overcommit
if type overcommit > /dev/null 2>&1 ; then
  export GIT_TEMPLATE_DIR=$(overcommit --template-dir)
else
  [[ "$-" == *i* ]] && echo "Please install overcommit command"
fi

# For a ipython notebook and pyspark integration
export SPARK_HOME="$(brew --prefix apache-spark)/libexec"
#export PYSPARK_SUBMIT_ARGS=" --master local[4] pyspark-shell ${PYSPARK_SUBMIT_ARGS}"
# Add the PySpark classes to the Python path:
export PYTHONPATH="${SPARK_HOME}/python/:${PYTHONPATH}"
export PYTHONPATH="${SPARK_HOME}/python/lib/py4j-0.10.1-src.zip:${PYTHONPATH}"
# Hadoop
export HADOOP_HOME="$(brew --prefix hadoop)/libexec"
export PATH="${PATH}:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin"
export HADOOP_CONF_DIR="${HADOOP_HOME}/etc/hadoop"
export HADOOP_CLASSPATH="${HADOOP_CLASSPATH}:${HADOOP_HOME}/share/hadoop/tools/lib/*"
# Pig
export PIG_HOME="$(brew --prefix pig)/libexec"

# added by Anaconda3 2.5.0 installer
export PATH="${HOME}/anaconda3/bin:$PATH"

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
        if type screenfetch > /dev/null 2>&1 ; then
          screenfetch
        else
          echo "Please install screenfetch command:\nbrew install screenfetch"
        fi
        ;;
    "Darwin" )
        # https://github.com/obihann/archey-osx
        if type archey > /dev/null 2>&1 ; then
          archey -p
        else
          echo "Please install archey command:\nbrew install archey"
        fi

        export JAVA_HOME="$(/usr/libexec/java_home)"
        ;;
esac

