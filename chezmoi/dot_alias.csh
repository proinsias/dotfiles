# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#

alias . pwd
alias .. cd ..
alias - cd -

alias alais alias

alias bc "bc -l"
alias boss "cd ; clear"
alias bye "clear;logout"

alias cd 'cd \!*;echo $cwd'
alias close 'chmod g-w,o-rwx'
alias copy "cp -i"
alias count "ls \!* | wc -l"
alias cp "cp -i"

alias delete "move \!* ~/.Trash/"

alias ew "emacs -nw \!*"
alias e "emacs \!* &"
alias ec "chmod 600 \!* ; emacs \!* &"
alias em "emacs \!* &"
alias edita "chmod 600 ~/.alias ; em ~/.alias"
alias editc "chmod 600 ~/.cshrc ; em ~/.cshrc"
alias editl "chmod 600 ~/.login ; em ~/.login"

alias free "df"
alias ftp "ftp -i"

alias h "history"

alias ip "ifconfig -a | grep inet | grep broadcast"

alias k9 "kill -9 "

alias lastaccess "ls --G -Flhut"
alias l 'ls -FG'
alias ls 'ls -G'
#alias listtrash "ls  -Fa ~/Desktop/Trash/"
alias lallmore "ls  --G -Falh \!* | more"
alias lmore "ls  --G -F \!* | more"

alias mc "mv -i" # Stop calling Midnight Commander
alias me "whoami"
alias mine 'ps -eu ftod -o "user pid tty time comm" | grep ftod'
alias move "mv -i"
alias mroe more
alias mv "mv -i"

#alias open 'chmod go+r'

alias pwd           'echo $cwd'

alias remove "rm -i"
alias removebackups "delete *~ #*# .*~"
alias rm "rm -i"

alias scp 'scp -prC'
alias shut 'chmod go-r'
alias sortbysize "du -S | sort -n"
alias sourcec "source ~/.tcshrc"
alias sourcel "source ~/.login"
alias space "du -sh \!*"

alias t 'todo.sh -d /Users/ftod/.todo.cfg'
alias top "top -o cpu"

alias up "cd ../"
alias up2 "cd ../../"
alias up3 "cd ../../../"

#
# Unused aliases
#

# alias quota  "quota -v"

# Interactive operation...
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
#
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
# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in colour
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'                              #

alias t='todo.sh'
