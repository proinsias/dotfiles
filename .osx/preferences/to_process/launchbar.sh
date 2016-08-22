#!/bin/bash


defaults write at.obdev.LaunchBar.plist AlternativeQuitKeyEquivalent -bool true
defaults write at.obdev.LaunchBar.plist Autohide -bool true
defaults write at.obdev.LaunchBar.plist AutohideAnimation -string "0"
defaults write at.obdev.LaunchBar.plist AutomaticSpellingCorrectionEnabled -bool false
defaults write at.obdev.LaunchBar.plist CalculatorHotKey -string "4352@8"
defaults write at.obdev.LaunchBar.plist CalculatorHotKeyEnabled -bool true
defaults write at.obdev.LaunchBar.plist CalendarEventParser -string "1"
defaults write at.obdev.LaunchBar.plist ClipboardHistoryCapacity -string "20"
defaults write at.obdev.LaunchBar.plist ContinuousSpellCheckingEnabled -bool false
defaults write at.obdev.LaunchBar.plist GrammarCheckingEnabled -bool false
defaults write at.obdev.LaunchBar.plist InstantOpenThreshold -string "8827659"
defaults write at.obdev.LaunchBar.plist InstantSendTargetMapping -data 61623966643932353362356364353639363632313636396535323666653231666461656630393035
defaults write at.obdev.LaunchBar.plist LaunchBarHotKey -string "4096@49"
defaults write at.obdev.LaunchBar.plist LaunchBarWindowWidth -string "600"
defaults write at.obdev.LaunchBar.plist ModifierTapActivation -string "13"
defaults write at.obdev.LaunchBar.plist ModifierTapInstantSend -string "23"
defaults write at.obdev.LaunchBar.plist PasteClipboardHistoryHotKeyEnabled -bool false
defaults write at.obdev.LaunchBar.plist PreferredTerminal -string "1"
defaults write at.obdev.LaunchBar.plist RetypeDelay -string "0.7"
defaults write at.obdev.LaunchBar.plist SelectFromClipboardHistoryHotKeyEnabled -bool false
defaults write at.obdev.LaunchBar.plist ShowClipboardHistoryHotKey -string "4096@39"
defaults write at.obdev.LaunchBar.plist ShowDockIcon -bool false
defaults write at.obdev.LaunchBar.plist SnippetsHotKey -string "4352@1"
defaults write at.obdev.LaunchBar.plist SnippetsHotKeyEnabled -bool true
defaults write at.obdev.LaunchBar.plist SoftwareUpdateCheckAutomatically -bool true
defaults write at.obdev.LaunchBar.plist SoftwareUpdateShowPreReleaseVersions -bool true
defaults write at.obdev.LaunchBar.plist SpotlightHotKey -string "4352@49"
defaults write at.obdev.LaunchBar.plist SpotlightHotKeyEnabled -bool false
defaults write at.obdev.LaunchBar.plist SwitchToCalculatorAutomatically -bool false
defaults write at.obdev.LaunchBar.plist WelcomeWindowVersion -string "1"

CFPreferencesAppSynchronize "at.obdev.LaunchBar.plist"
