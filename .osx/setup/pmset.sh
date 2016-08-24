#!/bin/bash

echo "###############################################################################"
echo "pmset"
echo "###############################################################################"

echo ""
echo "Speeding up wake from sleep to 24 hours from an hour"
# http://www.cultofmac.com/221392/quick-hack-speeds-up-retina-macbooks-wake-from-sleep-os-x-tips/
pmset -a standbydelay 86400

#echo ""
#echo "Disable computer sleep and stop the display from shutting off"
#pmset -a sleep 0
#pmset -a displaysleep 0

echo "###############################################################################"
echo "SSD"
echo "###############################################################################"

#echo ""
#echo "Disable hibernation (speeds up entering sleep mode)"
#pmset -a hibernatemode 0

#echo ""
#echo "Remove the sleep image file to save disk space"
#rm /Private/var/vm/sleepimage

#echo ""
#echo "Create a zero-byte file instead..."
#touch /Private/var/vm/sleepimage
#echo "...and make sure it can’t be rewritten"
#chflags uchg /Private/var/vm/sleepimage

echo ""
echo "Disable the sudden motion sensor as it’s not useful for SSDs"
pmset -a sms 0

