#!/bin/bash

echo "###############################################################################"
echo "System Preferences/App Store"
echo "###############################################################################"

echo ""
echo "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

CFPreferencesAppSynchronize "com.apple.SoftwareUpdate"
