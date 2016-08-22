#!/bin/bash

echo "###############################################################################"
echo "SSD"
echo "###############################################################################"

#echo ""
#echo "Disable local Time Machine snapshots"
#tmutil disablelocal

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

