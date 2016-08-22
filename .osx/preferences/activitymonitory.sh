#!/bin/bash

echo "###############################################################################"
echo "Activity Monitor"
echo "###############################################################################"

echo ""
echo "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

echo ""
echo "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5

echo ""
echo "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0

echo ""
echo "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

CFPreferencesAppSynchronize "com.apple.ActivityMonitor"

echo ""
echo "Killing application in order to take effect."
killall "Activity Monitor" > /dev/null 2>&1
