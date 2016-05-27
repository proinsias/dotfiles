# Setup fzf
# ---------

HOMEBREW_PREFIX=$(brew --prefix)

if [[ ! "$PATH" == "*$HOMEBREW_PREFIX/opt/fzf/bin*" ]]; then
  export PATH="$PATH:$HOMEBREW_PREFIX/opt/fzf/bin"
fi

# Man path
# --------
if [[ ! "$MANPATH" == "*$HOMEBREW_PREFIX/opt/fzf/man*" && -d "$HOMEBREW_PREFIX/opt/fzf/man" ]]; then
  export MANPATH="$MANPATH:$HOMEBREW_PREFIX/opt/fzf/man"
fi

# Auto-completion
# ---------------
# Check if in interactive shell
[[ $- == *i* ]] && source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.bash"

