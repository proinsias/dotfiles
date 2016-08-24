#!/bin/bash

echo "###############################################################################"
echo "systemsetup"
echo "###############################################################################"

# Never go into computer sleep mode
# systemsetup -setcomputersleep Off > /dev/null

#echo ""
#echo "Never go into computer sleep mode"
#systemsetup -setcomputersleep Off > /dev/null

echo ""
echo "Set the timezone"
#See `sudo systemsetup -listtimezones` for other values
systemsetup -settimezone "America/New_York" > /dev/null


