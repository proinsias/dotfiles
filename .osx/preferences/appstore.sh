#!/bin/bash

echo "###############################################################################"
echo "Address Book"
echo "###############################################################################"

echo ""
echo "Enable the WebKit Developer Tools in the Mac App Store"
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

echo ""
echo "Enable Debug Menu in the Mac App Store"
defaults write com.apple.appstore ShowDebugMenu -bool true

CFPreferencesAppSynchronize "com.apple.appstore"

echo ""
echo "Killing application in order to take effect."
killall "App Store" > /dev/null 2>&1
