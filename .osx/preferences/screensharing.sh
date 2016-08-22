#!/bin/bash

echo "###############################################################################"
echo "ScreenSharing.app"
echo "###############################################################################"

echo ""
echo "Turn on Bonjour browser"
defaults write com.apple.ScreenSharing ShowBonjourBrowser_Debug 1

echo ""
echo "Show the full toolbar"
defaults write com.apple.ScreenSharing \
	 'NSToolbar Configuration ControlToolbar' -dict-add \
	 'TB Item Identifiers' \
	 '(Scale,Control,Share,Curtain,Capture,FullScreen,GetClipboard,SendClipboard,Quality)'

CFPreferencesAppSynchronize "com.apple.ScreenSharing"

echo ""
echo "Killing application in order to take effect."
killall "Screen Sharing" > /dev/null 2>&1
