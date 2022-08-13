# This module contains useful shortcuts for fzf tool

bm-command-defined fzf || return

function bm-fzf-xdg-open() {
    local res=$(fzf)
    if [ ! -z "$res" ]; then
        echo xdg-open "$res" $@
    fi
}

bind '"\C-x": " \C-e\C-u`bm-fzf-xdg-open`\e\C-e\er\C-m"'
