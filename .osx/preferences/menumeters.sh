#!/bin/bash

echo "###############################################################################"
echo "Menu Meters"
echo "###############################################################################"

echo ""
echo "Update disk information only every 1s)
defaults write com.ragingmenace.MenuMeters.plist DiskInterval 1.0

CFPreferencesAppSynchronize "com.ragingmenace.MenuMeters"
