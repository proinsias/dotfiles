#!/bin/bash

echo "###############################################################################"
echo "NSGlobalDomain and Apple Global Domain"
echo "###############################################################################"

#echo ""
#echo "Menu bar: disable transparency"
#defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

#echo ""
#echo "Set highlight color to a specific yellow"
#defaults write NSGlobalDomain AppleHighlightColor -string '0.984300 0.929400 0.450900'

echo ""
echo "Always show scrollbars"
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

echo ""
echo "Disable opening and closing window animations"
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

echo ""
echo "Set language and text formats"
defaults write NSGlobalDomain AppleLanguages -array "en" "nl"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=USD"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

echo ""
echo "Increasing the window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo ""
echo "Expanding the save panel by default"
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

echo ""
echo "Displaying ASCII control characters using caret notation in
standard text views"
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

#echo ""
#echo "Disabling system-wide resume"
#defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

#echo ""
#echo "Disabling automatic termination of inactive apps"
#defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

echo ""
echo "Saving to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

echo ""
echo "Set sidebar icon size to 'medium'"
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

echo ""
echo "Disable smart quotes and smart dashes as they're annoying when typing code"
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo ""
echo "Adding a Safari context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo ""
echo "Trackpad: enable tap to click for this user and for the login screen"
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo ""
echo "Enabling full keyboard access for all controls (e.g. enable Tab in modal dialogs)"
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

#echo ""
#echo "Trackpad: map bottom right corner to right-click"
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
#defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

#echo ""
#echo "Disable “natural” (Lion-style) scrolling"
#defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

#echo ""
#echo "Disabling press-and-hold for keys in favor of a key repeat"
#defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

#echo ""
#echo "Setting a blazingly fast keyboard repeat rate (ain't nobody got time fo special chars while coding!)"
#defaults write NSGlobalDomain KeyRepeat -int 0

#echo ""
#echo "Disabling auto-correct"
#defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

#echo ""
#echo "Hide the menu bar"
#defaults write "Apple Global Domain" "_HIHideMenuBar" 1cho ""

echo ""
echo "Use 24-hour format"
defaults write "Apple Global Domain" AppleICUForce24HourTime 1

echo ""
echo "Use Monday as the first day of the week"
defaults write "Apple Global Domain" AppleFirstWeekday = '{
        gregorian = 2;
        }'

CFPreferencesAppSynchronize "NSGlobalDomain"
CFPreferencesAppSynchronize "Apple Global Domain"
