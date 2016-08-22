#!/bin/bash

echo "###############################################################################"
echo "Spotlight"
echo "###############################################################################"

#echo ""
#echo "Hide Spotlight tray-icon (and subsequent helper)"
#chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `mdutil -i off "/Volumes/foo"` to stop indexing any volume.
defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"

defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 0;"name" = "DIRECTORIES";}' \
  '{"enabled" = 0;"name" = "PDF";}' \
  '{"enabled" = 0;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}'

# Load new settings before rebuilding the index
 killall mds > /dev/null 2>&1

# Make sure indexing is enabled for the main volume
mdutil -i on / > /dev/null

# Rebuild the index from scratch
mdutil -E / > /dev/null

CFPreferencesAppSynchronize "com.apple.spotlight"

