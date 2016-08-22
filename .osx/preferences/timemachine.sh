#!/bin/bash

echo "###############################################################################"
echo "Time Machine"
echo "###############################################################################"

echo ""
echo "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#echo ""
#echo "Disable local Time Machine backups"
#hash tmutil &> /dev/null && tmutil disablelocal

CFPreferencesAppSynchronize "com.apple.TimeMachine"
