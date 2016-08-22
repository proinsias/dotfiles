#!/bin/bash


defaults write com.surteesstudios.Bartender.plist barLocationPercentage -1
defaults write com.surteesstudios.Bartender.plist bartenderClick 1
defaults write com.surteesstudios.Bartender.plist showMenuBarIcon -bool true
defaults write com.surteesstudios.Bartender.plist showBarAtStartup -bool true

CFPreferencesAppSynchronize "com.surteesstudios.Bartender.plist"
