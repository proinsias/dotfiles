#!/bin/bash

echo "###############################################################################"
echo "npm"
echo "###############################################################################"

# Setup caching
npm config set cache-min 9999999

npm install -g csslint
npm install -g dockerlint
npm install -g dockerfile_lint
npm install -g eslint
npm install -g git-guilt
npm install -g how2  # https://github.com/santinic/how2
npm install -g htmlhint
npm install -g jscs
npm install -g jshint
npm install -g jslint
npm install -g semistandard
npm install -g standard
npm install -g svgo
npm install -g tldr  # http://tldr.sh/
npm install -g wakatimecli  # https://www.npmjs.com/package/wakatimecli # https://wakatime.com
