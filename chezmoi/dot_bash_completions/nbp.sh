_nbp_completion() {
    local IFS=$'
'
    # shellcheck disable=SC2207
    COMPREPLY=($(env COMP_WORDS="${COMP_WORDS[*]}" \
        COMP_CWORD="${COMP_CWORD}" \
        _NBP_COMPLETE=complete_bash "${1}"))
    return 0
}

complete -o default -F _nbp_completion nbp
