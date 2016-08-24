#!/bin/bash

echo "###############################################################################"
echo "Photos"
echo "###############################################################################"

echo ""
echo "Disable Photos.app from starting everytime a device is plugged in"
defaults -currentHost write com.apple.ImageCapture disableHotPlug \
	 -bool true

CFPreferencesAppSynchronize "com.apple.ImageCapture"

#echo ""
#echo "Killing application in order to take effect."
#killall "Address Book" > /dev/null 2>&1
