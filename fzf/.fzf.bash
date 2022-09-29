# Setup fzf
# ---------
# shellcheck disable=SC2154
if [[ ! "${PATH}" == */"${HOMEBREW_PREFIX}"/opt/fzf/bin* ]]; then
    export PATH="${PATH:+${PATH}:}/${HOMEBREW_PREFIX}/opt/fzf/bin"
fi

# Auto-completion
# ---------------
# shellcheck disable=SC1091
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.bash" 2>/dev/null

# Key bindings
# ------------
# shellcheck disable=SC1091
source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.bash"
