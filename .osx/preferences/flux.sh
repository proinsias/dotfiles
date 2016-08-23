#!/bin/bash

echo "###############################################################################"
echo "Address Book"
echo "###############################################################################"

#echo ""
#echo ""
#defaults write org.herf.Flux.plist transitionSpeed -string "1"

#echo ""
#echo ""
#defaults write org.herf.Flux.plist SUSendProfileInfo -bool false

echo ""
echo "Set flag that Flux has launched before"
defaults write org.herf.Flux.plist SUHasLaunchedBefore -bool true

echo ""
echo "Enable automatic update checks"
defaults write org.herf.Flux.plist SUEnableAutomaticChecks -bool true

CFPreferencesAppSynchronize "org.herf.Flux.plist"

echo ""
echo "Killing application in order to take effect."
killall "Flux" > /dev/null 2>&1
