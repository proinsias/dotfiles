_clipy_completion() {
    local IFS=$'
'
    COMPREPLY=($(env COMP_WORDS="${COMP_WORDS[*]}" \
        COMP_CWORD="${COMP_CWORD}" \
        _CLI.PY_COMPLETE=complete_bash "${1}"))
    return 0
}

complete -o default -F _clipy_completion cli.py
