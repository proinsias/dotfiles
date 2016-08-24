#!/bin/bash

echo "###############################################################################"
echo "Bartender"
echo "###############################################################################"

#echo ""
#echo ""
#defaults write com.surteesstudios.Bartender.plist barLocationPercentage -1

#echo ""
#echo ""
#defaults write com.surteesstudios.Bartender.plist bartenderClick 1

echo ""
echo "Show menu bar icon"
defaults write com.surteesstudios.Bartender.plist showMenuBarIcon -bool true

echo ""
echo "Show menu bar at startup"
defaults write com.surteesstudios.Bartender.plist showBarAtStartup -bool true

CFPreferencesAppSynchronize "com.surteesstudios.Bartender.plist"

echo ""
echo "Killing application in order to take effect."
killall "Bartender" > /dev/null 2>&1
