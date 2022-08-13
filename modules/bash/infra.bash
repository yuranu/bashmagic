# This module contains functions for use by other modules.
# If it grows too much - make sure to separate it into multiple topics

# Define some colors
bm_col_lightgray="\033[0;37m"
bm_col_white="\033[1;37m"
bm_col_black="\033[0;30m"
bm_col_darkgray="\033[1;30m"
bm_col_red="\033[0;31m"
bm_col_lightred="\033[1;31m"
bm_col_green="\033[0;32m"
bm_col_lightgreen="\033[1;32m"
bm_col_brown="\033[0;33m"
bm_col_yellow="\033[1;33m"
bm_col_blue="\033[0;34m"
bm_col_lightblue="\033[1;34m"
bm_col_magenta="\033[0;35m"
bm_col_lightmagenta="\033[1;35m"
bm_col_cyan="\033[0;36m"
bm_col_lightcyan="\033[1;36m"
bm_col_nocolor="\033[0m"

function bm-err() {
    echo "$@" 2>&1
}

# bm-command-defined CMD
# Check if the given command is defined
function bm-command-defined() {
    local cmd="$@"
    [ -z "${cmd}" ] && return 1
    type "${cmd}" >/dev/null 2>&1
}

# bm-trim VALUE
# print the VALUE without leading or trailing spaces
function bm-trim() {
    var=$@
    var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
    echo -n "$var"
}

# bm-string-replace STRING REPLACEMENT OFFSET
# Print STRING with REPLACEMENT string at OFFSET
function bm-string-replace() {
    local str="$1"
    local rep="$2"
    local off="$3"
    echo "${str:0:${off}}${rep}${str:$((${off} + ${#rep}))}"
}

# bm-is-valid-var-name VARNAME
# Return success if given VARNAME is valid variable name in bash
function bm-is-valid-var-name() {
    var="$1"
    if [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        return 0
    else
        return 1
    fi
}

# bm-varappend VARNAME SEP VALUES...
# Append SEP separated values to var named VARNAME, if not already there
function bm-varappend() {
    var="$1"
    sep="$2"
    if ! bm-is-valid-var-name "${var}"; then
        return 127
    fi
    case ${sep} in
    ';' | ':' | ' ' | ',') ;;

    *)
        return 127
        ;;
    esac
    shift
    shift
    for ((i = $#; i > 0; i--)); do
        arg=${!i}
        if [[ "${sep}${!var}${sep}" != *"${sep}${arg}${sep}"* ]]; then
            if [ -z "${!var}" ]; then
                eval "${var}=\"${arg}\""
            else
                eval "${var}=\"${!var}${sep}${arg}\""
            fi
        fi
    done
}

# bm-varappend VARNAME VALUES...
# Prepend SEP separated values to var named VARNAME, if not already there
# Currently allow only a limited set of separators
function bm-varprepend() {
    var="$1"
    sep="$2"
    if ! bm-is-valid-var-name "${var}"; then
        return 127
    fi
    case "${sep}" in
    ';' | ':' | ' ' | ',') ;;

    *)
        return 127
        ;;
    esac
    shift
    shift
    for ((i = $#; i > 0; i--)); do
        arg=${!i}
        if [[ "${sep}${!var}${sep}" != *"${sep}${arg}${sep}"* ]]; then
            if [ -z "${!var}" ]; then
                eval "${var}=\"${arg}\""
            else
                eval "${var}=\"${arg}${sep}${!var}\""
            fi
        fi
    done
}

# Note: Currently allowing adding non existing directories to PATH.
# This sounds like a valid use case to me, though not common. May change.
alias bm-pathappend="bm-varappend PATH :"
alias bm-pathprepend="bm-varprepend PATH :"

# bm-hook HOOKNAME [-a|-p] CALLBACKS
# This is used as shortcuts to add hooks to BM events
function bm-hook() {
    local hook=$1
    local action=$2

    if ! bm-is-valid-var-name "${hook}"; then
        return 127
    fi

    case "${action}" in
    -a)
        action="append"
        shift
        ;;
    -p)
        action="prepend"
        shift
        ;;
    *)
        action="append"
        ;;
    esac

    shift

    hook="__bm_hook_${hook}"

    "bm-var${action}" "${hook}" ":" "$@"
}

# bm-whatismyip
# print this machine public ip
function bm-whatismyip() {
    curl ifconfig.me
    echo
}

# bm-distro
# Print the current distro name or "unknown" if couldn't identify
# For consistency, always use strictly lower case
function bm-distro() {
    if ! bm-command-defined lsb_release; then
        echo "unknown"
        return 1
    fi
    lsb_release -i | grep -oP ":\s*\K.*" | tr '[:upper:]' '[:lower:]'
}

# bm-is-wsl
# Check if currently running under WSL
alias bm-is-wsl="uname -r | grep -i microsoft >/dev/null 2>&1"
