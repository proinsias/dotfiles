#!/bin/bash


defaults write com.agilebits.onepassword4-helper.plist CheckForSoftwareUpdatesEnabled -bool true
defaults write com.agilebits.onepassword4-helper.plist ClearPasteboardAfterTimeout -bool false
defaults write com.agilebits.onepassword4-helper.plist ClearPasteboardAfterTimeout -bool false
defaults write com.agilebits.onepassword4-helper.plist CompletedEssentialSettings -bool true
defaults write com.agilebits.onepassword4-helper.plist ConcealPasswords -bool false
defaults write com.agilebits.onepassword4-helper.plist Enable3rdPartyIntegration -bool true
defaults write com.agilebits.onepassword4-helper.plist HashSectionIsSortedFirst -bool false
defaults write com.agilebits.onepassword4-helper.plist LockOnIdle -bool false
defaults write com.agilebits.onepassword4-helper.plist LockOnMainAppExit -bool false
defaults write com.agilebits.onepassword4-helper.plist LockOnScreenSaver -bool false
defaults write com.agilebits.onepassword4-helper.plist LockOnSleep -bool true
defaults write com.agilebits.onepassword4-helper.plist LockOnUserSwitch -bool true
defaults write com.agilebits.onepassword4-helper.plist LockTimeout -string 5
defaults write com.agilebits.onepassword4-helper.plist PasswordLength 16
defaults write com.agilebits.onepassword4-helper.plist PasswordPronounceable -bool true
defaults write com.agilebits.onepassword4-helper.plist PasswordRecipeVisible -bool true
defaults write com.agilebits.onepassword4-helper.plist PasswordUseDigits -bool true
defaults write com.agilebits.onepassword4-helper.plist PasswordUseHyphen -bool false
defaults write com.agilebits.onepassword4-helper.plist PasswordUseSymbols -bool false
defaults write com.agilebits.onepassword4-helper.plist PasteboardClearTimeout -string "90"
defaults write com.agilebits.onepassword4-helper.plist ShowBackupCompletedNotifications -bool true
defaults write com.agilebits.onepassword4-helper.plist ShowCopyJSONItemMenu -bool true
defaults write com.agilebits.onepassword4-helper.plist ShowCopyUUIDItemMenu -bool true
defaults write com.agilebits.onepassword4-helper.plist ShowRichIcons -bool true
defaults write com.agilebits.onepassword4-helper.plist ShowStatusItem -bool true
defaults write com.agilebits.onepassword4-helper.plist WelcomeWindowShown -bool false
defaults write com.agilebits.onepassword4-helper.plist animateFill -bool true
defaults write com.agilebits.onepassword4-helper.plist autosave -bool true
defaults write com.agilebits.onepassword4-helper.plist autosubmit -bool true

CFPreferencesAppSynchronize "com.agilebits.onepassword4-helper.plist"
