#SYSTEM_DIR=/usr/local/dotfiles
#if [ -r $SYSTEM_DIR/system.profile ]; then
#  . $SYSTEM_DIR/system.profile
#fi

if [ -r ~/.user.profile ]; then
  . ~/.user.profile
fi

if [ -r ~/.alias.ksh ]; then
  . ~/.alias.ksh
fi
