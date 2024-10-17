#!/usr/bin/env bash

set -o errexit    # Exit on error. Append || true if you expect an error.
set -o errtrace   # Exit on error inside any functions or subshells.
set -o noclobber  # Don't allow overwriting files.
set -o nounset    # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail   # Produce a failure return code if any pipeline command errors.
shopt -s failglob # Cause globs that don't get expanded to cause errors.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

if type stow >/dev/null 2>&1; then
    cd "${SCRIPT_DIR}"/

    mkdir -p "${HOME}/.local/bin"

    stow --target="${HOME}" \
        base \
        ansible \
        archey4 \
        aspell \
        bash \
        boto \
        broot \
        bundle \
        cheat \
        conda \
        curl \
        direnv \
        emacs \
        gdb \
        git \
        gitlint \
        glow \
        gnupg \
        htop \
        httpie \
        hunspell \
        ipython \
        jupyter \
        kitty \
        ksh \
        mog \
        neofetch \
        nix \
        npm \
        oh-my-zsh \
        pet \
        prettier \
        python \
        pylint \
        rubocop \
        screen \
        scripts \
        shellcheck \
        sourcery \
        ssh \
        starship \
        svn \
        tcsh \
        thefuck \
        tmux \
        tmuxinator \
        vim \
        vnc \
        wget \
        yamllint \
        zsh

    case $(hostname -s) in
    "francis-odonovan-macbook")
        stow --target="${HOME}" \
            francis-odonovan-macbook-atuin \
            francis-odonovan-macbook-gitconfig
        ;;
    "Mercury")
        stow --target="${HOME}" \
            mercury-gitconfig
        ;;
    "ilovemovies")
        stow --target="${HOME}" \
            ilovemovies-gitconfig
        ;;
    *)
        stow --target="${HOME}" \
            default-atuin \
            default-gitconfig
        ;;
    esac

    case $(uname -s) in
    "Linux")
        stow --target="${HOME}" \
            linux-gnupg \
            linux-npm
        ;;
    "Darwin")
        case $(uname -m) in
        "x86_64")
            stow --target="${HOME}" x86-64-gnupg
            ;;
        "arm64")
            stow --target="${HOME}" arm64-gnupg
            ;;
        *) ;;

        esac
        ;;
    *) ;;

    esac

    cp ./non-stow/.[a-z]* "${HOME}"/.

    cd -
else
    echo "Install stow using: "
    echo "> brew install stow"
    echo "or:"
    echo "> sudo apt-get update --yes && sudo apt-get install stow --yes"
fi
