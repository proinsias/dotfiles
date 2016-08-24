#!/bin/bash

echo "###############################################################################"
echo "launchctl"
echo "###############################################################################"

echo ""
echo "Turn on locate db"
launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist

#echo ""
#echo "Disable Notification Center and remove the menu bar icon"
#launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null
