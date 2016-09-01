#!/bin/bash

echo "###############################################################################"
echo "Opera & Opera Developer"
echo "###############################################################################"

# Expand the print dialog by default
defaults write com.operasoftware.Opera PMPrintingExpandedStateForPrint2 -boolean true
defaults write com.operasoftware.OperaDeveloper PMPrintingExpandedStateForPrint2 -boolean true

CFPreferencesAppSynchronize "com.operasoftware.Opera"
CFPreferencesAppSynchronize "com.operasoftware.OperaDeveloper"

echo ""
echo "Killing application in order to take effect."
killall "Opera" > /dev/null 2>&1

