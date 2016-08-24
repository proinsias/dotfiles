#!/bin/bash

echo "###############################################################################"
echo "System Preferences/Security & Privacy"
echo "###############################################################################"

echo ""
echo "Turn on Firewall"
defaults write /Library/Preferences/com.apple.alf globalstate -int 1
# /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

echo "Want to enable FileVault?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) fdesetup enable
	  break;;
    No ) exit;;
  esac
done

echo ""
echo "Enable stealth mode"
defaults write /Library/Preferences/com.apple.alf stealthenabled 1

echo ""
echo "Allow signed applications to receive incoming connections"
defaults write /Library/Preferences/com.apple.alf allowsignedenabled 1

#echo ""
#echo "Disabling OS X Gate Keeper"
#echo "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
#spctl --master-disable
#defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
#defaults write com.apple.LaunchServices LSQuarantine -bool false

CFPreferencesAppSynchronize /Library/Preferences/com.apple.alf
CFPreferencesAppSynchronize /var/db/SystemPolicy-prefs.plist
CFPreferencesAppSynchronize com.apple.LaunchServices
