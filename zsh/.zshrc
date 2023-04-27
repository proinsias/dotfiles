# User dependent .zshrc file

# Umask
#
# /etc/profile sets 022, removing write perms to group + others.
# Set a more restrictive umask: i.e. no exec perms for others:
# umask 027
# Paranoid: neither group nor others have any perms:
# umask 077

# Shell options
# http://zsh.sourceforge.net/Doc/Release/Options.html

# DIRSTACKSIZE keeps the directory stack from getting too large, much like HISTSIZE
# DIRSTACKSIZE=8

## Changing directories
setopt auto_cd           # if a command isn't valid, but is a directory, cd to that dir
setopt auto_pushd        # make cd push the old directory onto the directory stack
setopt pushd_ignore_dups # don't push multiple copies of the same directory onto the directory stack
setopt pushd_to_home     # have pushd with no arguments act like 'pushd $HOME'.
# setopt pushd_minus
# setopt pushd_silent      # keep shell from printing the directory stack each time we do a cd

## Completions
setopt always_to_end    # move cursor to the end of a completed word
setopt auto_list        # automatically list choices on ambiguous completion
setopt auto_menu        # show completion menu on a successive tab press
setopt auto_param_slash # if completed parameter is a directory, add a trailing slash
setopt complete_in_word # complete from both ends of a word
unsetopt menu_complete  # don't autoselect the first completion entry

## Expansion and Globbing
setopt extended_glob # use more awesome globbing features
setopt glob_dots     # include dotfiles when globbing

## History
setopt append_history         # append to history file
setopt extended_history       # write the history file in the ':start:elapsed;command' format
unsetopt hist_beep            # don't beep when attempting to access a missing history entry
setopt hist_expire_dups_first # expire a duplicate event first when trimming history
setopt hist_find_no_dups      # don't display a previously found event
setopt hist_ignore_all_dups   # delete an old recorded event if a new event is a duplicate
setopt hist_ignore_dups       # don't record an event that was just recorded again
setopt hist_ignore_space      # don't record an event starting with a space
setopt hist_no_store          # don't store history commands
setopt hist_reduce_blanks     # remove superfluous blanks from each command line being added to the history list
setopt hist_save_no_dups      # don't write a duplicate event to the history file
setopt hist_verify            # don't execute immediately upon history expansion
setopt inc_append_history     # write to the history file immediately, not when the shell exits
setopt share_history          # share history between all sessions

## Input/Output
unsetopt clobber   # must use >| to truncate existing files
setopt correct     # try to correct the spelling of commands
setopt correct_all # try to correct the spelling of all arguments in a line
setopt ignore_eof  # Do not exit on end-of-file.
# unsetopt flow_control          # disable start/stop characters in shell editor
setopt interactive_comments # enable comments in interactive shell
unsetopt mail_warning       # don't print a warning message if a mail file has been accessed
setopt path_dirs            # perform path search even on command names with slashes
# setopt rc_quotes               # allow 'Henry''s Garage' instead of 'Henry'\''s Garage'
unsetopt rm_star_silent # ask for confirmation for `rm *' or `rm path/*'
setopt rm_star_wait     # if asking for confirmation, wait 10 seconds before accepting response.

## Job Control
setopt auto_resume        # attempt to resume existing job before creating a new process
unsetopt bg_nice          # don't run all background jobs at a lower priority
setopt check_jobs         # report on jobs when shell exit
setopt check_running_jobs # check for both running and suspended jobs
unsetopt hup              # don't kill jobs on shell exit
setopt long_list_jobs     # list jobs in the long format by default
setopt notify             # report status of background jobs immediately

## Prompting
setopt prompt_subst # expand parameters in prompt variables

## Zle
# http://zsh.sourceforge.net/Doc/Release/Options.html#Zle
unsetopt beep          # be quiet!
setopt combining_chars # combine zero-length punctuation characters (accents) with the base character
setopt emacs           # use emacs keybindings in the shell

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="random"
# Use starship instead.

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' mode reminder # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

zstyle ':completion:*' menu select

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# shellcheck disable=SC2034
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# shellcheck disable=SC2034
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# shellcheck disable=SC2034
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
# https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins
# shellcheck disable=SC2034
plugins=(
    # asdf # FIXME:
    # autojump # FIXME:
    # aws
    # bundler
    # charm
    colored-man-pages
    # colorize
    command-not-found
    # dash
    direnv
    docker
    docker-compose
    fasd
    # fzf
    # gcloud
    gem
    gh
    git-auto-fetch
    gitfast
    github
    # golang
    gpg-agent
    httpie
    # keychain
    # mosh
    npm
    pip
    # pipenv
    poetry
    pylint
    # ripgrep
    # screen
    # ssh-agent
    yarn
    zsh-autosuggestions
    zsh-syntax-highlighting
)

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
    ;;
*) ;;
esac

# Completion setup before loading Oh My Zsh.

## tab completion for npm
# shellcheck disable=SC2065,SC2154
if ! test -f "${HOMEBREW_PREFIX}/share/zsh-completions/_npm" &>/dev/null; then
    npm completion >"${HOMEBREW_PREFIX}/share/zsh-completions/_npm"
fi

## Global tab completion for argcomplete-supported apps
# shellcheck disable=SC2065,SC2154
if test -d "${HOMEBREW_PREFIX}/share/zsh-completions" &>/dev/null; then
    FPATH="${HOMEBREW_PREFIX}/share/zsh-completions:${FPATH}"
else
    echo "Install zsh-completions using: brew install zsh-completions"
fi

# https://github.com/ellie/atuin/blob/main/docs/shell-completions.md
# https://github.com/chubin/cheat.sh#tab-completion
# https://github.com/zricethezav/gitleaks
# https://nbpreview.readthedocs.io/en/latest/usage.html?highlight=completion#cmdoption-nbpreview-install-completion
fpath+=~/.zfunc

case $(hostname -s) in
"booth")
    # I'm not the main user on this machine
    # shellcheck disable=SC2034
    ZSH_DISABLE_COMPFIX=true
    ;;
*) ;;

esac

# shellcheck disable=SC1091
source "${ZSH}/oh-my-zsh.sh"
# Should run the following:
# autoload -U bashcompinit
# autoload -Uz compinit
# bashcompinit
# compinit

# User configuration

## Exports

# Preferred editor for local and remote sessions
if [[ -n "${SSH_CONNECTION}" ]]; then
    export EDITOR='vi'
else
    export EDITOR='emacsclient'
fi

### For hunspell.
export LANG=en_US.UTF-8
export DICTIONARY=en_US
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

### Google Cloud
export CLOUDSDK_PYTHON="${HOMEBREW_PREFIX}/bin/python3"

### https://github.com/chrisallenlane/cheat
### cheat allows you to create and view interactive cheatsheets on the command-line.
export CHEATCOLORS=true

### To enable support via ssh-add.
export SSH_AUTH_SOCK="${HOME}/.1password/agent.sock"

export NPM_PACKAGES="${HOME}/.npm-packages"

### For homebrew
export HOMEBREW_INSTALL_CLEANUP=true

### For git
export GIT_EDITOR=emacsclient
export ALTERNATE_EDITOR=""
export GIT_TEMPLATE_DIR="${HOME}"/.git-template

### Go Lang
export GOPATH="${HOME}/golang"
export GOROOT="${HOMEBREW_PREFIX}/opt/go/libexec"

### GPG
OUTPUT="$(tty)"
export GPG_TTY="${OUTPUT}"

### os-specific exports

case $(uname -s) in
"Linux") ;;

"Darwin")
    # export JAVA_HOME="$(/usr/libexec/java_home)"  # Need Java8 not Java9 for Spark.
    # export PATH="${PATH:+${PATH}:}${JAVA_HOME}/bin"
    # export SCALA_HOME="${HOMEBREW_PREFIX}/opt/scala/idea"  # To use with IntelliJ.

    # Disable per-session command history feature in El Capitan
    # <https://stackoverflow.com/questions/32418438/how-can-i-disable-bash-sessions-in-os-x-el-capitan>
    export SHELL_SESSION_HISTORY=0
    ;;
*) ;;

esac

### ruby
export RUBY_HOME="${HOMEBREW_PREFIX}/opt/ruby"
export RUBY_VERSION="3.1.0"
export GEM_HOME="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"
export GEM_PATH="${RUBY_HOME}/lib/ruby/gems/${RUBY_VERSION}"

### pyenv
export PYENV_ROOT="${HOME}/.pyenv"

### Prevent accidental global package install through pip.
export PIP_REQUIRE_VIRTUALENV=true

### Ensure pipenv creates its own virtual environments for projects.
export PIPENV_IGNORE_VIRTUALENVS=1

### Add .NET Core SDK tools
export DOTNET_ROOT="${HOMEBREW_PREFIX}/dotnet/libexec"
export DOTNET_ROLL_FORWARD="LatestMajor"

### To install homebrew casks in /Applications by default
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

### Setup man path.
export MANPATH="${NPM_PACKAGES}/share/man${MANPATH:+:${MANPATH}}" # Keep first.

#### Set MANPATH so it includes users' private man if it exists
# shellcheck disable=SC2065
if test -d "${HOME}/man" >/dev/null 2>&1; then
    export MANPATH="${HOME}/man:${MANPATH}"
fi

export MANPATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnuman:${MANPATH}"

export MANPATH="${HOMEBREW_PREFIX}/opt/findutils/share/man:${MANPATH}"

export MANPATH="${HOMEBREW_PREFIX}/share/man:${MANPATH}"

### Setup info path.

# Set INFOPATH so it includes users' private info if it exists
# shellcheck disable=SC2065
if test -d "${HOME}/info" >/dev/null 2>&1; then
    export INFOPATH="${HOME}/info${INFOPATH:+:${INFOPATH}}" # Keep first.
fi

export INFOPATH="${HOMEBREW_PREFIX}/share/info:${INFOPATH}"

### Setup dic path.

#### For hunspell
export DICPATH="${HOME}/.hunspell_default:${HOMEBREW_PREFIX}/share/hunspell${DICPATH:+:${DICPATH}}" # Keep first.

### Setup LDFLAGS

##### Intel homebrew
test -d /usr/local/lib && export LDFLAGS="-L/usr/local/lib ${LDFLAGS}"
##### M1 homebrew – do second in case we are also using Intel via Rosetta.
test -d /opt/homebrew/lib && export LDFLAGS="-L/opt/homebrew/lib ${LDFLAGS}"

### Setup CPPFLAGS

#### Intel homebrew
test -d /usr/local/include && export CPPFLAGS="-L/usr/local/include ${CPPFLAGS}"
#### M1 homebrew – do second in case we are also using Intel via Rosetta.
test -d /opt/homebrew/include && export CPPFLAGS="-L/opt/homebrew/include ${CPPFLAGS}"

### Setup path.
export PATH="${HOME}/.local/bin${PATH:+:${PATH}}" # Keep first.
export PATH="${PATH}:${NPM_PACKAGES}/bin"
export PATH="${RUBY_HOME}/bin:${PATH}"
export PATH="${PATH}:${GEM_PATH}/bin"

#### set PATH so it includes user's private bin if it exists
if [[ -d "${HOME}/bin" ]]; then
    export PATH="${HOME}/bin:${PATH}"
fi

if [[ -d "${HOME}/.generic/bin" ]]; then
    export PATH="${PATH}:${HOME}/.generic/bin"
fi

#### Add homebrew's GNU coreutils (ls, cat, etc.) to PATH, etc. - see
#http://www.topbug.net/blog/2013/04/14/install-and-use-gnu-command-line-tools-in-mac-os-x/
# May cause issues - e.g., archey doesn't work with 'gawk'
#export PATH="${HOMEBREW_PREFIX}/opt/coreutils/libexec/gnubin${PATH:+:${PATH}}"

#### Add homebrew's GNU findutils to PATH:
#export PATH="${HOMEBREW_PREFIX}/opt/findutils/bin${PATH:+:${PATH}}"

#### Ccache
export PATH="${HOMEBREW_PREFIX}/opt/ccache/libexec:${PATH}"

#### Go lang.
export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:${GOROOT}/bin"

#### Add .NET Core SDK tools
export PATH="${PATH}:${HOME}/.dotnet/tools"

#### pyenv
export PATH="${PYENV_ROOT}/bin:${PATH}"
OUTPUT="$(pyenv init --path)"
eval "${OUTPUT}" # Puts shims dir as prefix to PATH.

#### Google Cloud SDK.
if [[ -f '/usr/local/google-cloud-sdk/path.zsh.inc' ]]; then
    . '/usr/local/google-cloud-sdk/path.zsh.inc'
fi

#### macOS
if [[ -d "${HOME}/.osx/bin" ]]; then
    export PATH="${PATH}:${HOME}/.osx/bin"
fi

#### ubunbtu
if [[ -d "${HOME}/.ubuntu/bin" ]]; then
    export PATH="${PATH:+${PATH}:}${HOME}/.ubuntu/bin"
fi

# If not running interactively, stop here
[[ "$-" != *i* ]] && return
# Use the generic form above instead of this PyCHarm/IntelliJ-specific way.
# if [ -n "${INTELLIJ_ENVIRONMENT_READER}" ]; then
#     return
# fi
#

# Completion setup after loading Oh My Zsh.

## tab completion for poetry
## https://python-poetry.org/docs/
# shellcheck disable=SC2065,SC2154
if ! test -f "${ZSH_CUSTOM}/plugins/poetry/_poetry" &>/dev/null; then
    echo "Install poetry completions using: mkdir ${ZSH_CUSTOM}/plugins/poetry &&" \
        "poetry completions zsh > ${ZSH_CUSTOM}/plugins/poetry/_poetry"
fi

## AWS bash completion
complete -C aws_completer aws

## tab completion for conda
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

## tab completion for whalebrew
# shellcheck disable=SC2065
if type whalebrew >/dev/null 2>&1; then
    OUTPUT="$(whalebrew completion zsh)"
    eval "${OUTPUT}"
fi

## The next line enables shell command completion for gcloud.
if [[ -f '/usr/local/google-cloud-sdk/completion.zsh.inc' ]]; then
    . '/usr/local/google-cloud-sdk/completion.zsh.inc'
fi

## Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# shellcheck disable=SC2086,SC2312
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ${HOME}/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh

## pipx (https://github.com/pipxproject/pipx)
# shellcheck disable=SC2065
if type pipx >/dev/null 2>&1; then
    OUTPUT="$(register-python-argcomplete pipx)"
    eval "${OUTPUT}"
else
    echo "Install pipx using: brew install pipx"
fi

## os-specific tab completions

case $(uname -s) in
"Linux") ;;

"Darwin")
    # Add tab completion for `defaults read|write NSGlobalDomain`
    # You could just use `-g` instead, but I like being explicit
    complete -W "NSGlobalDomain" defaults

    # Add `killall` tab completion for common apps
    complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall
    ;;
*) ;;

esac

# Setup various commands

## A smarter cd command - use z instead of cd.
# https://github.com/ajeetdsouza/zoxide
if type zoxide >/dev/null 2>&1; then
    export _ZO_ECHO=1 # Print the matched directory before navigating to it.
    OUTPUT="$(zoxide init zsh)"
    eval "${OUTPUT}"
else
    echo "Install zoxide using: brew install zoxide"
fi

## A utility for sending notifications, on demand and when commands finish.
## https://github.com/dschep/ntfy/
# shellcheck disable=SC2065
# if type ntfy >/dev/null 2>&1; then
#     OUTPUT="$(ntfy shell-integration --foreground-too)"
#     eval "${OUTPUT}"
#     export AUTO_NTFY_DONE_IGNORE="aws-shell ec emacs glances ipython jupyter man meld ""\
# psql screen tmux vim"
# fi

## make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && OUTPUT="$(SHELL=/bin/sh lesspipe)" && eval "${OUTPUT}"

## "Magnificent app which corrects your previous console command"
# shellcheck disable=SC2065
if type thefuck >/dev/null 2>&1; then
    OUTPUT="$(thefuck --alias)"
    eval "${OUTPUT}"
else
    echo "Install thefuck using: brew install thefuck"
fi

## pyenv
# shellcheck disable=SC2065
if type pyenv >/dev/null 2>&1; then
    OUTPUT="$(pyenv init --path)" # Puts shims dir as prefix to PATH.
    eval "${OUTPUT}"
    OUTPUT="$(pyenv init -)"
    eval "${OUTPUT}"
    OUTPUT="$(pyenv virtualenv-init -)"
    eval "${OUTPUT}"
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
else
    echo "Install pyenv using: brew install pyenv"
fi

## Wrap git automatically with hub
## https://hub.github.com/
if type hub >/dev/null 2>&1; then
    OUTPUT="$(hub alias -s)"
    eval "${OUTPUT}"
else
    echo "Install hub using: brew install hub"
fi

## fzf
# shellcheck disable=SC2065
if type fzf >/dev/null 2>&1; then
    # Ensure we have the right files. It's dependent on
    # HOMEBREW_PREFIX so I don't keep it in version control.
    if ! test -f "${HOME}"/.fzf.zsh; then
        "${HOMEBREW_PREFIX}/opt/fzf/install" --all --no-update-rc
    fi
    if test -f "${HOME}"/.fzf.zsh; then
        # shellcheck disable=SC1091
        source "${HOME}"/.fzf.zsh
    fi
else
    echo "Install fzf using: brew install fzf"
fi

## Add keychain keys - use 1password instead for ssh key
# # shellcheck disable=SC2065
# if type keychain >/dev/null 2>&1; then
#     OUTPUT="$(keychain --eval --agents gpg --ignore-missing --inherit any 6519D396 740CFB25 97FAE23F)"
#     eval "${OUTPUT}"
# else
#     echo "Install keychain using: brew install keychain"
# fi

## Add 1password-cli session
# shellcheck disable=SC2065
if type op >/dev/null 2>&1; then
    OUTPUT="$(op signin --account slesnonovans)"
    eval "${OUTPUT}"
else
    echo "Install 1password-cli using: brew cask install 1password-cli"
fi

# Don't need this with use of keychain.
# ssh-add -A  # Add all identities stored in your keychain.
# ssh-add ~/.ssh/id_rsa
# To add identities, run:
# ssh-add -K ~/.ssh/id_rsa

## Starship
# shellcheck disable=SC2065
if type starship >/dev/null 2>&1; then
    OUTPUT="$(starship init zsh)"
    eval "${OUTPUT}"
else
    echo "Install starship using: brew install starship"
fi

# ## http://direnv.net/
# Installed above as plugin.
# # shellcheck disable=SC2065
# if type direnv >/dev/null 2>&1; then
#     OUTPUT="$(direnv hook zsh)"
#     eval "${OUTPUT}"
# else
#     echo "Install direnv using: brew install direnv"
# fi

# shellcheck disable=SC2065
if type atuin >/dev/null 2>&1; then
    OUTPUT="$(atuin init zsh)"
    eval "${OUTPUT}"
    # zinit load ellie/atuin
else
    echo "Install atuin using: brew install atuin"
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

    # homebrew openssh with keychain support doesn't work anymore?
    # Below use Apple's ssh-add, rather than brew ssh-add
    # Move to interactive-only part
    # No need to launch ssh-agent - should be done by default
    # /usr/bin/ssh-add -l &> /dev/null || /usr/bin/ssh-add -K # ~/.ssh/id_rsa

    ;;
*) ;;

esac

# Startup output commands

## istheinternetonfire.com
# shellcheck disable=SC2065
if ping -c 1 google.com >/dev/null 2>&1; then
    echo "Is the internet on fire?:"
    dig +short -t txt istheinternetonfire.com
fi

## pyjokes
# shellcheck disable=SC2065
if type pyjoke >/dev/null 2>&1; then
    echo
    echo "Joke of the Day:"
    pyjoke
fi

## tldr
# shellcheck disable=SC2065
if type tldr >/dev/null 2>&1; then
    echo
    echo "tldr random example"
    tldr --random-example
fi

## motd
# shellcheck disable=SC2065
if type motd >/dev/null 2>&1; then
    echo
    echo "tip of the day"
    motd
fi

echo

# Deduplicate PATH variable
PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
export PATH

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
# https://unix.stackexchange.com/a/587802/198328
# If you need to override existing oh-my-zsh aliases, then you would configure them at the bottom of the .zshrc file.
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /Users/ftod/.op/plugins.sh
