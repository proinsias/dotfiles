# User dependent .bash_profile file

# source the users profile if it exists
if [ -f "${HOME}/.profile" ] ; then
  source "${HOME}/.profile"
fi

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi

