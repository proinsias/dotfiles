#!/bin/bash


defaults write net.phere.GitX.plist PBHistorySearchMode 1
defaults write net.phere.GitX.plist PBHistorySelectedDetailIndex 0
defaults write net.phere.GitX.plist PBShowStageView -bool false
defaults write net.phere.GitX.plist PBUseRepositoryWatcher -bool false
defaults write net.phere.GitX.plist SUSendProfileInfo -bool false

CFPreferencesAppSynchronize "net.phere.GitX.plist"
