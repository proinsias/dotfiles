#!/usr/bin/env bash

set -o errexit                # Exit on error. Append || true if you expect an error.
set -o errtrace               # Exit on error inside any functions or subshells.
set -o noclobber              # Don't allow overwriting files.
set -o nounset                # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail               # Produce a failure return code if any pipeline command errors.
shopt -s failglob             # Cause globs that don't get expanded to cause errors.
shopt -s globstar 2>/dev/null # Match all files and zero or more sub-directories.

if type stow > /dev/null 2>&1 ; then
    stow --target="${HOME}" \
        base \
        ansible \
        aspell \
        bash \
        boto \
        broot \
        bundle \
        conda \
        direnv \
        emacs \
        fzf \
        gdb \
        git \
        gitlint \
        gnupg \
        htop \
        hunspell \
        ipython \
        jupyter \
        kitty \
        ksh \
        mog \
        pylint \
        rubocop \
        screen \
        scripts \
        ssh \
        starship \
        svn \
        tcsh \
        thefuck \
        tmux \
        vim \
        wget \
        yamllint \
        zsh

    case $(hostname -s) in
        "ilovemovies" )
              ;;
        "intleacht" )
            stow --target="${HOME}" intleacht-gitconfig
              ;;
    esac

    case $(uname -s) in
        "Linux" )
            stow --target="${HOME}" linux-npm
              ;;
        "Darwin" )
              ;;
    esac

    cp ./non-stow/.[a-z]* "${HOME}"/.
else
    echo "Install stow using: brew install stow"
fi
