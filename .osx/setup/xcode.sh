#!/bin/bash

echo "###############################################################################"
echo "Xcode"
echo "###############################################################################"

# http://stackoverflow.com/a/30585445
echo ""
echo "Install XCode command tools"
xcode-select --install && sudo xcodebuild -license accept
