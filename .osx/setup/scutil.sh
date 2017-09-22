#!/bin/bash

echo "###############################################################################"
echo "scutil"
echo "###############################################################################"

echo "Want to set the computer name? (as done via System Preferences → Sharing)"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) echo 'What is your computer name going to be?'
      read -r comp_name
      scutil --set ComputerName "$comp_name"
      scutil --set HostName "$comp_name"
      scutil --set LocalHostName "$comp_name"
      defaults write \
      /Library/Preferences/SystemConfiguration/com.apple.smb.server \
      NetBIOSName -string "$comp_name"
      break;;
    No )  exit;;
  esac
done

