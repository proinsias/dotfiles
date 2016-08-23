#!/bin/bash

# Set standby delay to 24 hours (default is 1 hour)
pmset -a standbydelay 86400

# Disable the sound effects on boot
# nvram SystemAudioVolume=" "

# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

echo ""
echo "Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window"
defaults write /Library/Preferences/com.apple.loginwindow \
	 AdminHostInfo HostName

# Restart automatically if the computer freezes
systemsetup -setrestartfreeze on

# Never go into computer sleep mode
# systemsetup -setcomputersleep Off > /dev/null

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Disable Notification Center and remove the menu bar icon
# launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2> /dev/null

# Set the timezone; see `systemsetup -listtimezones` for other values
systemsetup -settimezone "America/Los_Angeles" > /dev/null

#echo ""
#echo "Disable the crash reporter"
#defaults write com.apple.CrashReporter DialogType -string "none"

#echo ""
#echo "Disable the “Are you sure you want to open this application?” dialog"
#defaults write com.apple.LaunchServices LSQuarantine -bool false

