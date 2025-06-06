# Some example alias instructions
# If these are enabled they will be used instead of any instructions
# they may mask.  For example, alias rm='rm -i' will mask the rm
# application.  To override the alias instruction use a \ before, ie
# \rm will call the real rm not the alias.
#

# bash default-names

## coreutils

#alias base32="gbase32"
#alias base64="gbase64"
alias basename="gbasename"
#alias cat="gcat"
#alias cat="mog --followsymlinks"
alias cat="bat"
alias charm="pycharm"
#alias chcon="gchcon"
alias chgrp="gchgrp"
alias chmod="gchmod"
alias chown="gchown"
alias chroot="gchroot"
#alias cksum="gcksum"
#alias comm="gcomm"
alias cp='gcp -i'
#alias csplit="gcsplit"
alias cut="gcut"
alias date="gdate"
#alias dd="gdd"
alias df='gdf -h' # Default to human readable figures
alias dir="gdir"
#alias dircolors="gdircolors"
#alias dirname="gdirname"
alias du='gdu -h' # Default to human readable figures
alias echo="gecho"
alias edit="bbedit"
#alias env="genv"
#alias expand="gexpand"
#alias expr="gexpr"
#alias factor="gfactor"
#alias false="gfalse"
#alias fmt="gfmt"
#alias fold="gfold"
#alias groups="ggroups"
alias head="ghead"
#alias hostid="ghostid"
#alias id="gid"
#alias install="ginstall"
alias join="gjoin"
alias kill="gkill"
#alias link="glink"
alias ln="gln"
#alias logname="glogname"
#alias ls='gls --almost-all --classify --human-readable --color --quote-name -v' # natural sort
alias ls='eza --all --classify=auto --color=always --color-scale --icons=auto' # Natural sort by default.
alias md5sum="gmd5sum"
alias mkdir="gmkdir"
#alias mkfifo="gmkfifo"
#alias mknod="gmknod"
#alias mktemp="gmktemp"
alias mv="gmv -i"
alias nice="gnice"
#alias nl="gnl"
alias nohup="gnohup"
#alias nproc="gnproc"
#alias numfmt="gnumfmt"
#alias od="god"
#alias paste="gpaste"
#alias pathchk="gpathchk"
#alias pinky="gpinky"
#alias pr="gpr"
#alias printenv="gprintenv"
##alias printf="gprintf" # Causes issues in bash shell
#alias ptx="gptx"
#alias pwd="gpwd"
#alias readlink="greadlink"
#alias realpath="grealpath"
alias rm="grm -i"
alias rmdir="grmdir"
#alias runcon="gruncon"
#alias seq="gseq"
alias sha1sum="gsha1sum"
alias sha224sum="gsha224sum"
alias sha256sum="gsha256sum"
alias sha384sum="gsha384sum"
alias sha512sum="gsha512sum"
alias shred="gshred"
alias shuf="gshuf"
alias sleep="gsleep"
alias sort="gsort"
alias split="gsplit"
alias stat="gstat"
#alias stdbuf="gstdbuf"
#alias stty="gstty"
#alias sum="gsum"
#alias sync="gsync"
#alias tac="gtac"
alias tail="gtail"
alias tee="gtee"
#alias test="gtest"
#alias timeout="gtimeout"
alias touch="gtouch"
#alias tr="gtr"
alias true="gtrue"
#alias truncate="gtruncate"
alias tsort="gtsort"
alias tx='tmuxinator'
#alias tty="gtty"
alias uname="guname"
#alias unexpand="gunexpand"
alias uniq="guniq"
#alias unlink="gunlink"
alias uptime="guptime"
alias users="gusers"
#alias vdir="gvdir"
alias wc="gwc"
alias who="gwho"
alias whoami="gwhoami"
alias yes="gyes"

## findutils
#alias find="gfind" # causes issues in the bash shell
#alias locate="glocate"
#alias updatedb="gupdatedb"
#alias xargs="gxargs"

## gnu-indent
#alias indent="gindent"
#alias texinfo2man="gtexinfo2man"

## gnu-sed
alias sed="gsed"

## gnu-tar
alias tar="gtar"

## gnu-which
alias which="gwhich"

## ed
#alias ed="ged"
#alias red="gred"

## grep
alias grep='ggrep --color'        # show differences in colour
alias egrep='gegrep --color=auto' # show differences in colour
alias fgrep='gfgrep --color=auto' # show differences in colour

# main aliases

alias alais='alias'

# Lock the screen (when going AFK)
# alias afk="i3lock -c 000000"

alias bc="bc -l"
alias boss='cd ; clear'
alias bye='clear;logout'

# Kill all the tabs in Chrome to free up memory
# [C] explained: http://www.commandlinefu.com/commands/view/402/exclude-grep-from-your-grepped-output-of-ps-alias-included-in-description
alias chromekill="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

alias close='gchmod g-w,o-rwx'
alias copy='gcp -i'
# alias count='function _count(){ gls "$@" | gwc -l ; };_count'

# alias delete='function _delete(){ move "$@" ~/.Trash/ ; };_delete'

#alias ec='function _ec(){ emacsclient "$@" ; };_ec'
alias ec="emacsclient"
# alias emacs="emacsclient"
# alias emacs='function _ec(){ emacsclient "$@" ; };_ec'  # Breaks auto-completion. Just use `emacs -nw`.
# alias ew='function _ew(){ /usr/local/bin/emacs -nw "$@" ; };_ew'

alias free='df'
alias ftp='ftp -i'

alias gc='git checkout'
alias gd='git diff'
alias gs='git status --show-stash'
alias GS='git status --show-stash'
alias gp='git pull'

alias h='history'

alias ip='ifconfig -a | ggrep inet | ggrep broadcast'
#alias ip="dig +short myip.opendns.com @resolver1.opendns.com"

alias jl='jupyter lab'
alias jn='jupyter notebook'

alias k9='gkill -9='

alias ll='gls --almost-all --classify --human-readable --color --quote-name -v -l' # long list, natural sort
# Clean up LaunchServices to remove duplicates in the "Open With" menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

alias mc='gmv -i' # Stop calling Midnight Commander
alias me='whoami'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

alias move='gmv -i'
alias mroe='more'

#alias open='gchmod go+r'

alias path='echo -e ${PATH//:/\\n}'
# Pipe my private key to my clipboard.
alias prikey="more ~/.ssh/id_ed25519 | xclip -selection clipboard | echo '=> Private key copied to pasteboard.'"
# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_ed25519.pub | xclip -selection clipboard | echo '=> Public key copied to pasteboard.'"

# alias reload="exec ${SHELL} -l"
alias remove='grm -i'
alias removebackups='delete *~ #*# .*~'

alias scp='scp -prC'
alias shut='gchmod go-r'
alias sortbysize='gdu -S | gsort -n'
alias sourcec='source ~/.tcshrc'
alias sourcel='source ~/.login'

alias t='todo.sh -d /Users/ftod/.todo.cfg'

alias unmount='umount'
alias up='cd ../'
alias up2='cd ../../'
alias up3='cd ../../../'

#
# Misc :)
alias less='less -r' # raw control characters
# alias more='less'
alias more='bat'
alias whence='type -a' # where, of a sort

case $(guname -s) in
--"Linux")
    alias top='top -o %CPU'
    ;;
"Darwin")
    # OS X has no `md5sum`, so use `md5` as a fallback
    command -v md5sum >/dev/null || alias md5sum="md5"

    # OS X has no `sha1sum`, so use `shasum` as a fallback
    command -v sha1sum >/dev/null || alias sha1sum="shasum"

    # Show/hide hidden files in Finder
    alias show="defaults write com.apple.finder AppleShowAllFiles -bool
        gtrue && killall Finder"
    alias hide="defaults write com.apple.finder AppleShowAllFiles -bool
        false && killall Finder"

    # Hide/show all desktop icons (useful when presenting)
    alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool
        false && killall Finder"
    alias showdesktop="defaults write com.apple.finder CreateDesktop -bool
        gtrue && killall Finder"

    # Ring the terminal bell, and put a badge on Terminal.app's Dock icon
    # (useful when executing time-consuming commands)
    alias badge="tput bel"

    # Lock the screen (when going AFK)
    alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

    alias top='top -o cpu'
    ;;
*) ;;
esac
