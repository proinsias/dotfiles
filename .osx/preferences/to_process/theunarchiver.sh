#!/bin/bash


defaults write cx.c3.theunarchiver.plist openExtractedFolder -bool true
defaults write cx.c3.theunarchiver.plist extractionDestination 1

CFPreferencesAppSynchronize "cx.c3.theunarchiver.plist"

