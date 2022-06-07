#!/usr/bin/env bash

set -o errexit                # Exit on error. Append || true if you expect an error.
set -o errtrace               # Exit on error inside any functions or subshells.
set -o noclobber              # Don't allow overwriting files.
set -o nounset                # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail               # Produce a failure return code if any pipeline command errors.
shopt -s failglob             # Cause globs that don't get expanded to cause errors.
shopt -s globstar 2>/dev/null # Match all files and zero or more sub-directories.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if type stow > /dev/null 2>&1 ; then
    cd "${SCRIPT_DIR}"/..

    stow --target="${HOME}" \
        base \
        ansible \
        aspell \
        bash \
        boto \
        broot \
        bundle \
        cheat \
        conda \
        direnv \
        emacs \
        fzf \
        gdb \
        git \
        gitlint \
        gnupg \
        htop \
        httpie \
        hunspell \
        ipython \
        jupyter \
        kitty \
        ksh \
        mog \
        npm \
        pet \
        prettier \
        python \
        pylint \
        rubocop \
        screen \
        scripts \
        shellcheck \
        ssh \
        starship \
        svn \
        tcsh \
        thefuck \
        tmux \
        vim \
        vnc \
        wget \
        yamllint \
        zsh

    case $(hostname -s) in
        "ilovemovies" )
            stow --target="${HOME}" ilovemovies-gitconfig
            ;;
        "intleacht" )
            stow --target="${HOME}" intleacht-gitconfig
            ;;
    * )
        stow --target="${HOME}" default-gitconfig
        ;;
    esac

    case $(uname -s) in
        "Linux" )
            stow --target="${HOME}" \
                linux-gnupg \
                linux-npm
            ;;
        "Darwin" )
            case $(uname -m) in
                "amd64" )
                    stow --target="${HOME}" amd64-gnupg
                    ;;
                "arm64" )
                    stow --target="${HOME}" arm64-gnupg
                    ;;
            * )
                ;;
            esac
            ;;
    * )
        ;;
    esac

    cp ./non-stow/.[a-z]* "${HOME}"/.

    cd -
else
    echo "Install stow using: brew install stow"
fi
