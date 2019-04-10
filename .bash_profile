# User dependent .bash_profile file
# Should be super-simple and just load `.profile` and `.bashrc` (in that order)

# source the users profile if it exists
if [ -f "${HOME}/.profile" ] ; then
  source "${HOME}/.profile"
fi

# source the users bashrc if it exists
if [ -f "${HOME}/.bashrc" ] ; then
  source "${HOME}/.bashrc"
fi


# Setting PATH for Python 3.7
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.7/bin:${PATH}"
export PATH
