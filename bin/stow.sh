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

    # FIXME: GT gitconfig.

    # FIXME: Move ~/.config/ntfy to ntfy/.config/ntfy?

    # FIXME: GT:
    # etc_hosts
    # Why doesn't .gitignore get installed? - copy it manually
    # .bash
          #.envrc - needs editing
          #.ntfy.yml.template

    # FIXME:
    # if ubuntu
    # stow --target="${HOME}" ubuntu-npm

    cp ./non-stow/.[a-z]* "${HOME}"/.
else
    echo "Install stow using: brew install stow"
fi


# FIXME: Move scripts directory to base/bin/.local/bin/. MAKE SURE NO SECRETS!
# FIXME: Make bin script that git clones this repo and then runs stow!
# FIXME: Make sure .bashrc and .profile will work on any machine.
# FIXME: Test on ilovemovies and GCS VM machine.
# FIXME: Add vnc config files from GCS VM machine!
