#!/bin/bash

echo "###############################################################################"
echo "homebrew"
echo "###############################################################################"

echo ""
echo "Install homebrew if necessary"
# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
      ruby -e "$(curl -fsSL
https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo ""
echo "Setting some permissions for homebrew."
chown -R $(whoami):admin $(brew --prefix)/bin
chown -R $(whoami):admin $(brew --prefix)/share/man/man1
chown -R $(whoami):admin $(brew --prefix)/lib
chown -R $(whoami):admin $(brew --prefix)/share

echo ""
echo "Update homebrew recipes"
brew update

echo ""
echo "Install ruby via homebrew's rbenv"
brew install rbenv ruby-build # Do not install ruby via homebrew!
echo Installing gem 2.5.1...
echo Use 'rbenv install -l' to list the possible versions and find
latest stable
rbenv install 2.5.1
rbenv global 2.5.1
echo Add the following to your .bashrc file:
echo 'export RBENV_ROOT="$(brew --prefix rbenv)"'
echo 'export GEM_HOME="$(brew --prefix)/opt/gems"'
echo 'export GEM_PATH="$(brew --prefix)/opt/gems"'
gem update --system
gem install bundler # http://bundler.io/

echo ""
echo "Add new bash, fish, zsh to the list of 'standard' shells"
# http://stackoverflow.com/a/791244
echo $(brew --prefix)/bin/bash >> /etc/shells
echo $(brew --prefix)/bin/fish >> /etc/shells
echo $(brew --prefix)/bin/zsh >> /etc/shells

echo ""
echo "Set bash as default shell for current user"
chsh -s $(brew --prefix)/bin/bash

