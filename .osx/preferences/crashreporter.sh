#!/bin/bash

echo "###############################################################################"
echo "Crash Reporter"
echo "###############################################################################"

#echo ""
#echo "Disable the crash reporter"
#defaults write com.apple.CrashReporter DialogType -string "none"

CFPreferencesAppSynchronize "com.apple.CrashReporter"

