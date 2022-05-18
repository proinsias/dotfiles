# Setup fzf
# ---------
if [[ ! "$PATH" == */opt/homebrew/opt/fzf/bin* ]]; then
    export PATH="$PATH:/opt/homebrew/opt/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == */opt/homebrew/opt/fzf/man* && -d "/opt/homebrew/opt/fzf/man" ]]; then
    export MANPATH="$MANPATH:/opt/homebrew/opt/fzf/man"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/opt/homebrew/opt/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
source "/opt/homebrew/opt/fzf/shell/key-bindings.bash"
