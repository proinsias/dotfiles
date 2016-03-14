# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#

alias alais='alias'

alias bc="bc -l"
alias boss='cd ; /usr/bin/clear'
alias bye='/usr/bin/clear;logout'

alias close='chmod g-w,o-rwx'
alias copy='/bin/cp -i'
alias count='function _count(){ ls "$@" | wc -l ; };_count'
alias cp='/bin/cp -i'

alias delete='function _delete(){ move "$@" ~/.Trash/ ; };_delete'

alias ew='function _ew(){ /usr/bin/emacs -nw "$@" ; };_ew'
alias e='function _e(){ /usr/bin/emacs "$@" & ; };_e'

alias free='/bin/df'
alias ftp='/usr/bin/ftp -i'

alias gc='git checkout'
alias gd='git diff'
alias gs='git status'
alias gp='git pull'

alias h='history'

alias ip='ifconfig -a | grep inet | grep broadcast'

alias jn='jupyter notebook'

alias k9='kill -9='

alias mc='/bin/mv -i' # Stop calling Midnight Commander
alias me='/usr/bin/whoami'
alias move='/bin/mv -i'
alias mroe='more'
alias mv='/bin/mv -i'

#alias open='chmod go+r'

alias remove='/bin/rm -i'
alias removebackups='delete *~ #*# .*~'
alias rm='/bin/rm -i'

alias scp='scp -prC'
alias shut='chmod go-r'
alias sortbysize='du -S | sort -n'
alias sourcec='source ~/.tcshrc'
alias sourcel='source ~/.login'

alias t='todo.sh -d /Users/ftod/.todo.cfg'
alias top='top -o cpu'

alias unmount='umount'
alias up='cd ../'
alias up2='cd ../../'
alias up3='cd ../../../'

# Default to human readable figures
alias df='df -h'
alias du='du -h'
#
# Misc :)
alias less='less -r'                          # raw control characters
alias more='less'
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in colour
alias egrep='egrep --color=auto'              # show differences in colour
alias fgrep='fgrep --color=auto'              # show differences in colour
#

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool
true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool
false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool
false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool
true && killall Finder"

# Ring the terminal bell, and put a badge on Terminal.app’s Dock icon
# (useful when executing time-consuming commands)
alias badge="tput bel"

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\
Extras/User.menu/Contents/Resources/CGSession -suspend"


