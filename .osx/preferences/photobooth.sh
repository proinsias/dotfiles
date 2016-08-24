#!/bin/bash

echo "###############################################################################"
echo "Photo Booth"
echo "###############################################################################"

echo ""
echo "Enable the debug menu in Photo Booth"
defaults write com.apple.PhotoBooth EnableDebugMenu 1

CFPreferencesAppSynchronize "com.apple.PhotoBooth"

echo ""
echo "Killing application in order to take effect."
killall "Photo Booth" > /dev/null 2>&1
