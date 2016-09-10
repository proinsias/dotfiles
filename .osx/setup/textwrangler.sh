#!/bin/bash

echo "###############################################################################"
echo "TextWrangler"
echo "###############################################################################"

echo ""
echo "Killing application in order to change theme"
killall "TextWrangler" > /dev/null 2>&1

echo ""
echo "Downloading solarized theme"
source_dir="${HOME}/Library/Application Support/BBColors"
mkdir -p "${source_dir}"
curl -B \
     "https://raw.githubusercontent.com/altercation/solarized/master/textwrangler-bbedit-colors-solarized/Solarized%20Dark.bbcolors"\
     -o "${source_dir}/Solarized Dark.bbcolors"

echo ""
echo "Use BBColors to install theme"
bbcolors -load "Solarized Dark" -tw
