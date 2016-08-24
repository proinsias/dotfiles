#!/bin/bash

echo "###############################################################################"
echo "ruby"
echo "###############################################################################"

bundle config build.nokogiri --use-system-libraries
bundle install --gemfile=~/.Gemfile
