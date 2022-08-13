# This module contains some useful aliases for VIM - the best text editor in
# the universe, curse you emacs

bm-command-defined vim || return

# My default editor is vim, of course
alias edit='vim'
alias ebrc='vim ~/.bashrc'

function bm-present() {
    vim -M "$@" -c PresentingStart -c Goyo
}

function __bm-vim() {
    local vimruntime=$(vim -e -T dumb --cmd 'exe "set t_cm=\<C-M>"|echo $VIMRUNTIME|quit' | tr -d '\015')
    [[ -z "${vimruntime}" ]] && {
        return
    }

    local vless="${vimruntime}/macros/less.sh"
    [[ -x "${vless}" ]] && alias vless="${vless}"
}

__bm-vim
