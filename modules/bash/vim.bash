# This module contains some useful aliases for VIM - the best text editor in
# the universe, curse you emacs

if ! bm-command-defined vim ; then
    if ! bm-command-defined nvim ; then
        return
    else
        alias vim=nvim
    fi
fi


# My default editor is vim, of course
alias edit='vim'
alias ebrc='vim ~/.bashrc'

function __bm-get-vim-runtime() {
    if bm-has-cmd nvim ; then
        echo /usr/share/nvim/runtime
        return 0
    fi

    if bm-has-cmd vim ; then
        vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015'
        return 0
    fi

    return 1
}

function __bm-vim() {
    local vimruntime=$(__bm-get-vim-runtime)
    [[ -z "${vimruntime}" ]] && {
        return
    }

    local vless="${vimruntime}/macros/less.sh"
    [[ -x "${vless}" ]] && alias vless="${vless}"
    [[ -x "${vless}" ]] && alias vlessl="${vless} -c 'set ft=log'"

    bm-has-cmd nvim && alias vim=nvim
}

__bm-vim

# All new function / aliases must be after this point, as this is the point
# where vim version is chosen

function bm-present() {
    vim -M "$@" -c PresentingStart -c Goyo
}

