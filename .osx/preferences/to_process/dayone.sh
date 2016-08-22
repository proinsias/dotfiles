#!/bin/bash


defaults write com.dayoneapp.dayone.plist AutoBackupEnabled -bool true
defaults write com.dayoneapp.dayone.plist AutoBackupFrequency -string "16"
defaults write com.dayoneapp.dayone.plist AutoBackupInterval -string "2"
defaults write com.dayoneapp.dayone.plist AutoBackupMaxCount -string "5"
defaults write com.dayoneapp.dayone.plist EditorCorrectSpellingEnabled -bool true
defaults write com.dayoneapp.dayone.plist EditorGrammarCheckEnabled -bool true
defaults write com.dayoneapp.dayone.plist EditorSpellCheckEnabled -bool true
defaults write com.dayoneapp.dayone.plist EmbedMediaEnabled -bool true
defaults write com.dayoneapp.dayone.plist FontSize -string "16"
defaults write com.dayoneapp.dayone.plist InspirationalMessagesEnabled -bool true
defaults write com.dayoneapp.dayone.plist LinkTwitterHandles -bool true
defaults write com.dayoneapp.dayone.plist ListViewSortOrder -string "0"
defaults write com.dayoneapp.dayone.plist MarkdownEnabled -bool true
defaults write com.dayoneapp.dayone.plist SecurityIdleLockEnabled -bool true
defaults write com.dayoneapp.dayone.plist SecurityIdleLockTime -string "20"
defaults write com.dayoneapp.dayone.plist SecurityPasswordProtectionEnabled -bool false
defaults write com.dayoneapp.dayone.plist SecuritySleepLockEnabled -bool true

CFPreferencesAppSynchronize "com.dayoneapp.dayone.plist"
