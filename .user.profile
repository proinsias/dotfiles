#!/bin/ksh

set -o emacs
set -o noclobber 
set -o notify # notifies you when background jobs finish running
export BASEPATH="$PATH" # To save original $PATH
export HISTSIZE=200

set -o histexpand # enables ! job history # Cygwin doesn't like this
set -o multiline # word wrap on command line # Cygwin doesn't like this

export PS1='${USER}@`hostname`:${PWD}:\!>} '

export PATH=/Users/ftod/bin:$PATH
