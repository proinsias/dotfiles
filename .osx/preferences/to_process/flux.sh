#!/bin/bash


defaults write org.herf.Flux.plist transitionSpeed -string "1"
defaults write org.herf.Flux.plist SUSendProfileInfo -bool false
defaults write org.herf.Flux.plist SUHasLaunchedBefore -bool true
defaults write org.herf.Flux.plist SUEnableAutomaticChecks -bool true

CFPreferencesAppSynchronize "org.herf.Flux.plist"
