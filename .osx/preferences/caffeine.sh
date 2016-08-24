#!/bin/bash

echo "###############################################################################"
echo "Caffeine"
echo "###############################################################################"

echo ""
echo "Activate on launch"
defaults write com.lightheadsw.caffeine.plist ActivateOnLaunch -bool false
echo ""
echo "Suppress launch message"
defaults write com.lightheadsw.caffeine.plist SuppressLaunchMessage -bool true
echo ""
echo "Set duration to infinity"
defaults write com.lightheadsw.caffeine.plist DefaultDuration -string "0"

CFPreferencesAppSynchronize "com.lightheadsw.caffeine.plist"

echo ""
echo "Killing application in order to take effect."
killall "Caffeine" > /dev/null 2>&1
