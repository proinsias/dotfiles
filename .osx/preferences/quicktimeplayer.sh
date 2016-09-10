#!/bin/bash

echo "###############################################################################"
echo "QuickTime Player"
echo "###############################################################################"

echo ""
echo "Auto-play videos when opened with QuickTime Player"
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

OACFPreferencesAppSynchronize "com.apple.QuickTimePlayerX"

echo ""
echo "Killing application in order to take effect."
killall "QuickTime Player" > /dev/null 2>&1
