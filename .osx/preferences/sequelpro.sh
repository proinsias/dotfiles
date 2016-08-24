#!/bin/bash

echo "###############################################################################"
echo "Sequel Pro"
echo "###############################################################################"

defaults write com.sequelpro.SequelPro.plist SPFirstRun -bool false

CFPreferencesAppSynchronize "com.sequelpro.SequelPro.plist"

echo ""
echo "Killing application in order to take effect."
killall "Sequel Pro" > /dev/null 2>&1
