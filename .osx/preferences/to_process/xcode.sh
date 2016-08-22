#!/bin/bash


if [ ! -f $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/Badwolf.dvtcolortheme ]; then

  if [ ! -d $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes ]; then

    mkdir $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes

  fi

  cp -v $HOME/.shmack/themes/Badwolf.dvtcolortheme $HOME/Library/Developer/Xcode/UserData/FontAndColorThemes/

fi

defaults write com.apple.dt.Xcode.plist AssistantEditorsLayout 1
defaults write com.apple.dt.Xcode.plist DVTDownloadableAutomaticUpdate -bool true
defaults write com.apple.dt.Xcode.plist DVTFontAndColorCurrentTheme -string "Badwolf.dvtcolortheme"
defaults write com.apple.dt.Xcode.plist IBAppliesAutoResizingRulesWhileResizing -bool false
defaults write com.apple.dt.Xcode.plist IBPreferencesMigrated -bool true
defaults write com.apple.dt.Xcode.plist IDESourceControlEnableSourceControl_5_0 -bool false
defaults write com.apple.dt.Xcode.plist XCShowWelcomeWindow -bool false

CFPreferencesAppSynchronize "com.apple.dt.Xcode.plist"

