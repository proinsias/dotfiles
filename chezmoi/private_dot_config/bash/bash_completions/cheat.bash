# cheat(1) completion                                      -*- shell-script -*-

# generate cheatsheet completions, optionally using `fzf`
# shellcheck disable=SC2120
_cheat_complete_cheatsheets() {
    # shellcheck disable=SC2154
    if [[ "${CHEAT_USE_FZF}" = true ]]; then
        FZF_COMPLETION_TRIGGER='' _fzf_complete "--no-multi" "${@}" < <(
            # shellcheck disable=SC2312
            cheat -l | tail -n +2 | cut -d' ' -f1
        )
    else
        # shellcheck disable=SC2312,SC2207
        COMPREPLY=($(compgen -W "$(cheat -l | tail -n +2 | cut -d' ' -f1)" -- "${cur}"))
    fi
}

# generate tag completions, optionally using `fzf`
_cheat_complete_tags() {
    if [[ "${CHEAT_USE_FZF}" = true ]]; then
        # shellcheck disable=SC2312
        FZF_COMPLETION_TRIGGER='' _fzf_complete "--no-multi" "$@" < <(cheat -T)
    else
        # shellcheck disable=SC2312,SC2207
        COMPREPLY=($(compgen -W "$(cheat -T)" -- "${cur}"))
    fi
}

# implement the `cheat` autocompletions
_cheat() {
    local cur prev split
    _init_completion -s || return

    # complete options that are currently being typed: `--col` => `--colorize`
    if [[ "${cur}" == -* ]]; then
        # shellcheck disable=SC2016,SC2207
        COMPREPLY=($(compgen -W '$(_parse_help "$1" | sed "s/=//g")' -- "${cur}"))
        # shellcheck disable=SC2128
        [[ ${COMPREPLY} == *= ]] && compopt -o nospace
        return
    fi

    # implement completions
    case "${prev}" in
    --colorize | -c | \
        --directories | -d | \
        --init | \
        --regex | -r | \
        --search | -s | \
        --tags | -T | \
        --version | -v)
        # noop the above, which should implement no completions
        ;;
    --edit | -e)
        _cheat_complete_cheatsheets
        ;;
    --list | -l)
        _cheat_complete_cheatsheets
        ;;
    --path | -p)
        # shellcheck disable=SC2312,SC2207
        COMPREPLY=($(compgen -W "$(cheat -d | cut -d':' -f1)" -- "${cur}"))
        ;;
    --rm)
        _cheat_complete_cheatsheets
        ;;
    --tag | -t)
        _cheat_complete_tags
        ;;
    *)
        _cheat_complete_cheatsheets
        ;;
    esac

    ${split} && return

} &&
    complete -F _cheat cheat

# ex: filetype=sh
