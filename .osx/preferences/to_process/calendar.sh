#!/bin/bash


# Enable the debug menu in iCal (pre-10.8)
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Default duration for new event
defaults write com.apple.iCal "Default duration in minutes for new event" 60

CFPreferencesAppSynchronize "com.apple.iCal"
