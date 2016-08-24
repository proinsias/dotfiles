#!/bin/bash

echo "###############################################################################"
echo "GPGMail 2"
echo "###############################################################################"

#echo ""
#echo "Disable signing emails by default"
#defaults write ~/Library/Preferences/org.gpgtools.gpgmail SignNewEmailsByDefault -bool false

CFPreferencesAppSynchronize "org.gpgtools.gpgmail"

#echo ""
#echo "Killing application in order to take effect."
#killall "Address Book" > /dev/null 2>&1
