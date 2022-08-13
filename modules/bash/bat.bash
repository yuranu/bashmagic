# This module contains some uses for the bat pager
# https://github.com/sharkdp/bat

function __bm-bat() {
    local bat=""
    bm-command-defined bat && bat=bat
    bm-command-defined batcat && bat=batcat
    [ -z "${bat}" ] && return

    export MANPAGER="bash -c 'col -b | ${bat} -l man -p'"

    if bm-command-defined fzf; then
        alias bm-linux-doc-fzf="find /usr/share/doc/linux/ -name '*.rst' -o -name '*.txt' | xargs -I {} bash -c \"cat -b {} | grep -P '\w' | sed 's|^|{}: |'\" | fzf | sed -E 's/^([^:]*):\s*([0-9]*).*/\1 --pager \"less -R +\2\"/' | xargs ${bat} -l rst"
    fi
}

__bm-bat
