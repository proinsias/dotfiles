#!/bin/bash


defaults write com.agilebits.onepassword4.plist CheckForSoftwareUpdatesEnabled -bool true
defaults write com.agilebits.onepassword4.plist ClearPasteboardAfterTimeout -bool false
defaults write com.agilebits.onepassword4.plist CompletedEssentialSettings -bool true
defaults write com.agilebits.onepassword4.plist ConcealPasswords -bool false
defaults write com.agilebits.onepassword4.plist Enable3rdPartyIntegration -bool true
defaults write com.agilebits.onepassword4.plist KeepHelperRunning -bool true
defaults write com.agilebits.onepassword4.plist LockOnIdle -bool false
defaults write com.agilebits.onepassword4.plist LockOnMainAppExit -bool false
defaults write com.agilebits.onepassword4.plist LockOnScreenSaver -bool true
defaults write com.agilebits.onepassword4.plist LockOnSleep -bool true
defaults write com.agilebits.onepassword4.plist LockTimeout -string "5"
defaults write com.agilebits.onepassword4.plist PasteboardClearTimeout -string "90"
defaults write com.agilebits.onepassword4.plist ShowBackupCompletedNotifications -bool true
defaults write com.agilebits.onepassword4.plist ShowCopyJSONItemMenu -bool true
defaults write com.agilebits.onepassword4.plist ShowCopyUUIDItemMenu -bool true
defaults write com.agilebits.onepassword4.plist ShowRichIcons -bool true
defaults write com.agilebits.onepassword4.plist ShowStatusItem -bool true
defaults write com.agilebits.onepassword4.plist WelcomeWindowShown -bool false
defaults write com.agilebits.onepassword4.plist animateFill -bool true
defaults write com.agilebits.onepassword4.plist autosave -bool true
defaults write com.agilebits.onepassword4.plist autosubmit -bool true

CFPreferencesAppSynchronize "com.agilebits.onepassword4.plist"

