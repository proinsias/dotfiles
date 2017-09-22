#!/bin/bash

echo "###############################################################################"
echo "Chrome Extensions"
echo "###############################################################################"

echo "Want to open the webpages for select Chrome extensions?"
select yn in "Yes" "No"; do
  case $yn in
    Yes ) open -a "Google Chrome" \
          https://agilebits.com/onepassword/extensions \
          https://chrome.google.com/webstore/detail/bookmark-manager/gmlllbghnfkpflemihljekbapjopfjik \
          https://chrome.google.com/webstore/detail/buffer/noojglkidnpfjbincgijbaiedldjfbhh?utm_source=chrome-ntp-icon \
          https://chrome.google.com/webstore/detail/chromebleed/eeoekjnjgppnaegdjbcafdggilajhpic \
          https://chrome.google.com/webstore/detail/feedly/hipbfijinpcgfogaopmgehiegacbhmob \
          https://chrome.google.com/webstore/detail/google-calendar/ejjicmeblgpmajnghnpcppodonldlgfn?utm_source=chrome-ntp-launcher \
          https://chrome.google.com/webstore/detail/google-docs-offline/ghbmnnjooekpmoecnnnilnnbdlolhkhi \
          https://chrome.google.com/webstore/detail/google-docs/aohghmighlieiainnegkcijnfilokake?utm_source=chrome-ntp-launcher \
          https://chrome.google.com/webstore/detail/https-everywhere/gcbommkclmclpchllfjekcdonpmejbdp \
          https://chrome.google.com/webstore/detail/motivation/ofdgfpchbidcgncgfpdlpclnpaemakoj \
          https://chrome.google.com/webstore/detail/save-to-pocket/niloccemoadcdkdjlinkgdfekeahmflj \
          https://chrome.google.com/webstore/detail/serum/ffboflhdigfmnnokjjcmfipgehggjhlj \
          https://chrome.google.com/webstore/detail/smile-always/jgpmhnmjbhgkhpbgelalfpplebgfjmbf \
          https://chrome.google.com/webstore/detail/the-great-suspender/klbibkeccnjlkjkiokjodocebajanakg \
          https://chrome.google.com/webstore/detail/throttle/klmapenfmenbohghcdlilacfhckhcbnn?utm_source=chrome-ntp-icon \
          https://chrome.google.com/webstore/detail/use-https/kbkgnojednemejclpggpnhlhlhkmfidi \
          https://chrome.google.com/webstore/detail/wakatime/jnbbnacmeggbgdjgaoojpmhdlkkpblgi \
          https://chrome.google.com/webstore/detail/gmail-offline/ejidjjhkpiempkbhmpbfngldlkglhimk?utm_source=chrome-ntp-launcher
      break;;
    No ) exit;;
  esac
done


