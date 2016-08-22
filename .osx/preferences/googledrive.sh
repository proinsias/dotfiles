#!/bin/bash

echo "###############################################################################"
echo "Google Drive"
echo "###############################################################################"

#echo ""
#echo ""
#defaults write com.google.GoogleDrive.plist DirectConnection -bool true

#echo ""
#echo ""
#defaults write com.google.GoogleDrive.plist overlayLogging -bool false

#echo ""
#echo ""
#defaults write com.google.GoogleDrive.plist thankyoushown -bool false

#echo ""
#echo ""
#defaults write com.google.GoogleDrive.plist usagestats -bool false

CFPreferencesAppSynchronize "com.google.GoogleDrive.plist"

echo ""
echo "Killing application in order to take effect."
killall "Google Drive" > /dev/null 2>&1
