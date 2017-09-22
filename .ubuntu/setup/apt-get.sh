#!/bin/bash

echo "###############################################################################"
echo "apt-get"
echo "###############################################################################"

echo ""
echo "Update apt-get"
apt-get update

echo ""
echo "Installing prerequisites for homebrew"
apt-get install build-essential curl git python-setuptools ruby
