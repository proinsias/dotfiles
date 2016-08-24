#!/bin/bash

echo "###############################################################################"
echo "Reminders.app"
echo "###############################################################################"

echo ""
echo "Show debug menu"
defaults write com.apple.reminders RemindersDebugMenu -boolean true

CFPreferencesAppSynchronize "com.apple.reminders"

echo ""
echo "Killing application in order to take effect."
killall "Reminders" > /dev/null 2>&1
