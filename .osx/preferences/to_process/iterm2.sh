#!/bin/bash


defaults write com.googlecode.iterm2 AdjustWindowForFontSizeChange -bool true
defaults write com.googlecode.iterm2 AllowClipboardAccess -bool true
defaults write com.googlecode.iterm2 AnimateDimming -bool false
defaults write com.googlecode.iterm2 AppleAntiAliasingThreshold 1
defaults write com.googlecode.iterm2 AppleScrollAnimationEnabled 0
defaults write com.googlecode.iterm2 AppleSmoothFixedFontsSizeThreshold 1
defaults write com.googlecode.iterm2 AppleSmoothFixedFontsSizeThreshold 1
defaults write com.googlecode.iterm2 AutoHideTmuxClientSession -bool false
defaults write com.googlecode.iterm2 CheckTestRelease -bool false
defaults write com.googlecode.iterm2 ClosingHotkeySwitchesSpaces -bool false
defaults write com.googlecode.iterm2 CommandSelection -bool false
defaults write com.googlecode.iterm2 Control 1
defaults write com.googlecode.iterm2 CopyLastNewline -bool false
defaults write com.googlecode.iterm2 CopySelection -bool false
defaults write com.googlecode.iterm2 DimBackgroundWindows -bool false
defaults write com.googlecode.iterm2 DimInactiveSplitPanes -bool true
defaults write com.googlecode.iterm2 DimOnlyText -bool true
defaults write com.googlecode.iterm2 DisableFullscreenTransparency -bool false
defaults write com.googlecode.iterm2 EnableRendezvous -bool false
defaults write com.googlecode.iterm2 FocusFollowsMouse -bool false
defaults write com.googlecode.iterm2 FsTabDelay 1.0947265625
defaults write com.googlecode.iterm2 HiddenAdvancedFontRendering -bool false
defaults write com.googlecode.iterm2 HideActivityIndicator -bool false
defaults write com.googlecode.iterm2 HideMenuBarInFullscreen -bool false
defaults write com.googlecode.iterm2 HideScrollbar -bool true
defaults write com.googlecode.iterm2 HideTab -bool true
defaults write com.googlecode.iterm2 HighlightTabLabels -bool true
defaults write com.googlecode.iterm2 HotKeyBookmark -string "BA49A3D5-D1B4-47AC-8DE5-501143AF35C8"
defaults write com.googlecode.iterm2 HotKeyTogglesWindow -bool false
defaults write com.googlecode.iterm2 Hotkey -bool true
defaults write com.googlecode.iterm2 HotkeyChar 32
defaults write com.googlecode.iterm2 HotkeyCode 49
defaults write com.googlecode.iterm2 HotkeyModifiers 786753
defaults write com.googlecode.iterm2 JobName -bool true
defaults write com.googlecode.iterm2 LeftCommand 7
defaults write com.googlecode.iterm2 LeftOption 2
defaults write com.googlecode.iterm2 MaxVertically -bool false
defaults write com.googlecode.iterm2 NSScrollAnimationEnabled -bool false
defaults write com.googlecode.iterm2 OnlyWhenMoreTabs -bool true
defaults write com.googlecode.iterm2 OpenArrangementAtStartup -bool false
defaults write com.googlecode.iterm2 OpenBookmark -bool false
defaults write com.googlecode.iterm2 PassOnControlClick -bool false
defaults write com.googlecode.iterm2 PasteFromClipboard -bool false
defaults write com.googlecode.iterm2 PromptOnClose -bool false
defaults write com.googlecode.iterm2 PromptOnQuit -bool false
defaults write com.googlecode.iterm2 PromptOnQuit -bool true
defaults write com.googlecode.iterm2 QuitWhenAllWindowsClosed -bool false
defaults write com.googlecode.iterm2 RightCommand 8
defaults write com.googlecode.iterm2 RightOption 3
defaults write com.googlecode.iterm2 SavePasteHistory -bool false
defaults write com.googlecode.iterm2 ShowBookmarkName -bool false
defaults write com.googlecode.iterm2 ShowPaneTitles -bool false
defaults write com.googlecode.iterm2 SmartPlacement -bool false
defaults write com.googlecode.iterm2 SplitPaneDimmingAmount 0.400000005960464
defaults write com.googlecode.iterm2 SwitchTabModifier 4
defaults write com.googlecode.iterm2 SwitchWindowModifier 6
defaults write com.googlecode.iterm2 TabViewType 0
defaults write com.googlecode.iterm2 ThreeFingerEmulates -bool false
defaults write com.googlecode.iterm2 TripleClickSelectsFullWrappedLines -bool false
defaults write com.googlecode.iterm2 UseBorder -bool false
defaults write com.googlecode.iterm2 UseCompactLabel -bool true
defaults write com.googlecode.iterm2 UseLionStyleFullscreen -bool false
defaults write com.googlecode.iterm2 WindowNumber -bool false
defaults write com.googlecode.iterm2 WindowStyle 0
defaults write com.googlecode.iterm2 WordCharacters -string "/-+\~_."
defaults write com.googlecode.iterm2 findIgnoreCase_iTerm -bool true
defaults write com.googlecode.iterm2 findRegex_iTerm -bool false


CFPreferencesAppSynchronize "com.googlecode.iterm2"
