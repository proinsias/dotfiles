#!/bin/bash

echo "###############################################################################"
echo "Xcode"
echo "###############################################################################"

# http://stackoverflow.com/a/30585445
echo ""
echo "Install XCode command tools"
xcode-select --install && sleep 1
osascript -e 'tell application "System Events"' -e 'tell process \
"Install Command Line Developer Tools"' -e 'keystroke return' -e \
	  'click button "Agree" of window "License Agreement"' -e 'end
tell' -e \
	  'end tell'

