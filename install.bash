#!/usr/bin/bash

declare __bm_install_token="Enable bashmagic. Please don't modify."

function __bm-usage() {
    echo "$(basename $0) [FLAGS] [DIR]
FLAGS:
    --tmux | Install tmux configuration
DIR:
    The destination installatio directory
    Default: HOME
"
}

function __bm-check-installed() {
    if grep "${__bm_install_token}" "$1" >/dev/null 2>&1; then
        echo "Already installed"
        return 1
    fi
    return 0
}

function __bm-root() {
    echo $(dirname $(realpath "$0"))
}

function __bm-first-file() {
    echo "$(__bm-root)/bashmagic.first.$1"
}

function __bm-install-bash() {
    local dst="$1/.bashrc"
    echo "Installing bash config to ${dst}"
    __bm-check-installed "${dst}" || return 0
    echo "
# ${__bm_install_token}
source \"$(__bm-first-file bash)\"
" >>"${dst}"
}

function __bm-install-tmux() {
    local dst="$1/.tmux.conf"
    echo "Installing tmux config to ${dst}"
    __bm-check-installed "${dst}" || return 0
    echo "
# ${__bm_install_token}
set-environment -g BM_TMUX_BASHMAGIC_DIR \"$(__bm-root)\"
source \"$(__bm-first-file tmux)\"
" >>"${dst}"
}

function __bm-install() {
    local is_tmux=false
    local dir=${HOME}

    local nargs=$#
    while [ "${nargs}" -gt 0 ]; do
        local arg=$1
        case "${arg}" in
        --help | -h)
            __bm-usage
            return 0
            ;;
        --tmux)
            is_tmux=true
            ;;
        *)
            dir=$1
            ;;
        esac
        shift
        nargs=$#
    done

    __bm-install-bash "${dir}" || { echo "Failed installing bashmagic base support" >&2 && return 127; }
    "${is_tmux}" && __bm-install-tmux "${dir}"

    return 0
}

__bm-install "$@"
