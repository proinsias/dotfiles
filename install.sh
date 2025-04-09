#!/usr/bin/env bash

set -o errexit    # Exit on error. Append || true if you expect an error.
set -o errtrace   # Exit on error inside any functions or subshells.
set -o noclobber  # Don't allow overwriting files.
set -o nounset    # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail   # Produce a failure return code if any pipeline command errors.
shopt -s failglob # Cause globs that don't get expanded to cause errors.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

# Make sure that these directories already exist so stow symlinks files not directories.
mkdir -p \
    ~/.bash \
    ~/.bash_completions \
    ~/.bundle \
    ~/.config/archey4 \
    ~/.config/atuin \
    ~/.config/broot \
    ~/.config/cheat \
    ~/.config/direnv \
    ~/.config/htop \
    ~/.config/kitty \
    ~/.config/neofetch \
    ~/.config/pet \
    ~/.config/sourcery \
    ~/.config/thefuck \
    ~/.config/tmuxinator \
    ~/.config/yamllint \
    ~/.doom.d \
    ~/.git-template/hooks \
    ~/.gnupg \
    ~/.httpie \
    ~/.hunspell_default \
    ~/.ipython \
    ~/.jupyter \
    ~/.local/bin \
    ~/.local/share/devbox/global/default \
    ~/.ssh \
    ~/.subversion/auth \
    ~/.vnc \
    ~/.zfunc/ \
    ~/Library/Preferences/glow

export ZSH="${ZSH:-${HOME}/.oh-my-zsh}"
if test -f "${ZSH}/oh-my-zsh.sh"; then
    mkdir -p "${ZSH}/custom"
else
    echo "Install oh-my-zsh via: https://ohmyz.sh/#install"
fi

if type op >/dev/null 2>&1; then
    op signin
    op plugin init aws
    op plugin init brew
    # op plugin init cdk  # AWS CDK
    # op plugin init dog  # DataDog
    op plugin init gh
    # op plugin init huggingface-cli
    # op plugin init kaggle
    # op plugin init mysql
    # op plugin init ngrok
    # op plugin init okta
    # op plugin init openai
    # op plugin init psql
    # op plugin init snowsql
fi

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
    "francis")
        stow --target="${HOME}" \
            francis-odonovan-macbook-atuin \
            francis-odonovan-macbook-gitconfig
        ;;
    "mercury")
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
