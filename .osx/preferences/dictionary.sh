#!/bin/bash

echo "###############################################################################"
echo "Dictionary"
echo "###############################################################################"

#Reuse dictionary definition window:
#$ defaults write com.apple.Dictionary ProhibitNewWindowForRequest -boolean

CFPreferencesAppSynchronize "com.apple.Dictionary"

echo ""
echo "Killing application in order to take effect."
killall "Dictionary" > /dev/null 2>&1
