#!/usr/bin/env bash

set -o errexit                # Exit on error. Append || true if you expect an error.
set -o errtrace               # Exit on error inside any functions or subshells.
set -o noclobber              # Don't allow overwriting files.
set -o nounset                # Don't allow use of undefined vars. Use ${VAR:-} to use an undefined VAR.
set -o pipefail               # Produce a failure return code if any pipeline command errors.
shopt -s failglob             # Cause globs that don't get expanded to cause errors.
shopt -s globstar 2>/dev/null # Match all files and zero or more sub-directories.

if type stow > /dev/null 2>&1 ; then
    # FIXME: Can I move below to base?
    stow --target="${HOME}" \
        ansible \
        aspell \
        bash \
        bundle \
        conda \
        direnv \
        fzf \
        git \
        gnupg \
        htop \
        ipython \
        jupyter \
        kitty \
        ksh \
        mog \
        ssh \
        starship \
        tcsh \
        thefuck \
        tmux \
        vim \
        yamllint \
        zsh

    # FIXME: GT gitconfig.
    # FIXME: Move misc scripts to base/.
    # FIXME: Move scripts directory to base/bin/.local/bin/. MAKE SURE NO SECRETS!

    # FIXME: Move ~/.config/ntfy to ntfy/.config/ntfy?

    # FIXME:
    # if ubuntu
    # stow --target="${HOME}" ubuntu-npm

    cp ./non-stow/.[a-z]* "${HOME}"/.
else
    echo "Install stow using: brew install stow"
fi


# FIXME: Make bin script that git clones this repo and then runs stow!
