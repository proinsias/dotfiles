#!/bin/bash

echo "###############################################################################"
echo "conda"
echo "###############################################################################"

if test ! $(which conda); then
    echo ""
    echo "Installing conda..."

    pyenv install miniconda3-latest
    pyenv global miniconda3-latest    
fi

echo ""
echo "Install requirements into the root environment"
echo "Start off by installing conda packages"
while read requirement; do
    conda install --yes $requirement;
done < requirements.txt
echo "Then install pip-only packages, if necessary"
pip install -r requirments.txt

