#!/bin/bash

echo "###############################################################################"
echo "conda"
echo "###############################################################################"

if test ! $(which conda); then
    echo ""
    echo "Installing conda..."

    case $(uname -s) in
        "Linux" )
            wget https://repo.continuum.io/archive/Anaconda3-4.1.1-Linux-x86_64.sh \
            --output-document=/tmp/Anaconda3.sh
            ;;
        "Darwin" )
            wget https://repo.continuum.io/archive/Anaconda3-4.1.1-MacOSX-x86_64.sh \
            --output-document=/tmp/Anaconda3.sh
            ;;

        bash /tmp/Anaconda3.sh
    esac
fi

echo ""
echo "Login to anaconda.org"
anaconda login

echo ""
echo "Add conda-forge channel"
conda config --add channels conda-forge

echo ""
echo "Install requirements into the root environment"
echo "Start off by installing conda packages"
while read requirement; do
    conda install --yes $requirement;
done < requirements.txt
echo "Then install pip-only packages, if necessary"
pip install -r requirments.txt

