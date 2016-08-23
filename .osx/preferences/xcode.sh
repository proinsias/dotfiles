#!/bin/bash

echo "###############################################################################"
echo "Xcode"
echo "###############################################################################"


echo ""
echo "Turn off welcome windows"
defaults write com.apple.dt.Xcode.plist XCShowWelcomeWindow -bool false

CFPreferencesAppSynchronize "com.apple.dt.Xcode.plist"

echo ""
echo "Killing application in order to take effect."
killall "Xcode" > /dev/null 2>&1
