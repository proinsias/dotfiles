#!/bin/bash


defaults write com.lightheadsw.caffeine.plist ActivateOnLaunch -bool false
defaults write com.lightheadsw.caffeine.plist SuppressLaunchMessage -bool true
defaults write com.lightheadsw.caffeine.plist DefaultDuration -string "0"

CFPreferencesAppSynchronize "com.lightheadsw.caffeine.plist"
