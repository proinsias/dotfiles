#!/bin/bash

echo "###############################################################################"
echo "TextWrangler"
echo "###############################################################################"

textwrangler_font='62706c6973743030d401020304050828295424746f7058246f626a65637473582476657273696f6e59246172636869766572d1060754726f6f748001a9090a0f191a1b1c1d2455246e756c6cd20b0c0d0e5624636c6173735f101a4e53466f6e7444657363726970746f724174747269627574657380088002d3100b111215165a4e532e6f626a65637473574e532e6b657973a21314800580068007a21718800380045f10134e53466f6e744e616d654174747269627574655f10134e53466f6e7453697a654174747269627574655d4d656e6c6f2d526567756c61722241900000d21e1f20215824636c61737365735a24636c6173736e616d65a32122235f10134e534d757461626c6544696374696f6e6172795c4e5344696374696f6e617279584e534f626a656374d21e1f2527a226235f10104e53466f6e7444657363726970746f725f10104e53466f6e7444657363726970746f7212000186a05f100f4e534b657965644172636869766572000800110016001f002800320035003a003c0046004c005100580075007700790080008b009300960098009a009c009f00a100a300b900cf00dd00e200e700f000fb00ff01150122012b0130013301460159015e0000000000000201000000000000002a00000000000000000000000000000170'

echo ""
echo "Set default font sizes"
defaults write com.barebones.textwrangler 'BBEditorFont' \
	 -data ${textwrangler_font}
defaults write com.barebones.textwrangler 'ListDisplayFont' \
	 -data ${textwrangler_font}

echo ""
echo "New files are markdown files"
defaults write com.barebones.textwrangler \
	 DefaultLanguageNameForNewDocuments -string “Markdown”

echo ""
echo "Display the amount of time required for Replace All operations."
defaults write com.barebones.textwrangler \
	 ReplaceAllResultsIncludeTiming -bool YES

CFPreferencesAppSynchronize "com.barebones.textwrangler"

echo ""
echo "Killing application in order to take effect."
killall "TextWrangler" > /dev/null 2>&1
