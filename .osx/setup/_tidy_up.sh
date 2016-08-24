#!/bin/bash

echo "###############################################################################"
echo "Tidy up"
echo "###############################################################################"

echo ""
echo "Reset Launchpad"
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1\
     -delete

echo ""
echo "Killing some open applications in order to take effect."
for app in  "cfprefsd" "SystemUIServer" ; do
  killall "${app}" > /dev/null 2>&1
done

echo ""
echo "Note that some of these changes require a logout/restart to take effect."
