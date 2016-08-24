#!/bin/bash

echo "###############################################################################"
echo "iTunes"
echo "###############################################################################"


#echo ""
#echo "Stop iTunes from responding to the keyboard media keys:"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.rcd.plist 2> /dev/null

echo ""
echo "Killing application in order to take effect."
killall "iTunes" > /dev/null 2>&1
