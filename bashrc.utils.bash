COL_LIGHTGRAY="\033[0;37m"
COL_WHITE="\033[1;37m"
COL_BLACK="\033[0;30m"
COL_DARKGRAY="\033[1;30m"
COL_RED="\033[0;31m"
COL_LIGHTRED="\033[1;31m"
COL_GREEN="\033[0;32m"
COL_LIGHTGREEN="\033[1;32m"
COL_BROWN="\033[0;33m"
COL_YELLOW="\033[1;33m"
COL_BLUE="\033[0;34m"
COL_LIGHTBLUE="\033[1;34m"
COL_MAGENTA="\033[0;35m"
COL_LIGHTMAGENTA="\033[1;35m"
COL_CYAN="\033[0;36m"
COL_LIGHTCYAN="\033[1;36m"
COL_NOCOLOR="\033[0m"

mydir() {
    echo "$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
    return 0
}

trim() {
    var=$@
    var="${var#"${var%%[![:space:]]*}"}" # remove leading whitespace characters
    var="${var%"${var##*[![:space:]]}"}" # remove trailing whitespace characters
    echo -n "$var"
}

exit_code_str() {
    if [[ $1 == 0 ]]; then
        echo "Success"
    elif [[ $1 == 1 ]]; then
        echo "General error"
    elif [ $1 == 2 ]; then
        echo "Missing keyword, command, or permission problem"
    elif [ $1 == 126 ]; then
        echo "Permission problem or command is not an executable"
    elif [ $1 == 127 ]; then
        echo "Command not found"
    elif [ $1 == 128 ]; then
        echo "Invalid argument to exit"
    elif [ $1 == 129 ]; then
        echo "Fatal error signal 1"
    elif [ $1 == 130 ]; then
        echo "Script terminated by Control-C"
    elif [ $1 == 131 ]; then
        echo "Fatal error signal 3"
    elif [ $1 == 132 ]; then
        echo "Fatal error signal 4"
    elif [ $1 == 133 ]; then
        echo "Fatal error signal 5"
    elif [ $1 == 134 ]; then
        echo "Fatal error signal 6"
    elif [ $1 == 135 ]; then
        echo "Fatal error signal 7"
    elif [ $1 == 136 ]; then
        echo "Fatal error signal 8"
    elif [ $1 == 137 ]; then
        echo "Fatal error signal 9"
    elif [ $1 -gt 255 ]; then
        echo "Exit status out of range"
    else
        echo "Unknown error code"
    fi

}

whatismyip() {
    curl ifconfig.me
}

distribution() {
    local dtype
    # Assume unknown
    dtype="unknown"

    if [ -r /etc/rc.d/init.d/functions ]; then
        source /etc/rc.d/init.d/functions
        [ zz$(type -t passed 2>/dev/null) == "zzfunction" ] && dtype="redhat"
    elif [ -r /etc/rc.status ]; then
        source /etc/rc.status
        [ zz$(type -t rc_reset 2>/dev/null) == "zzfunction" ] && dtype="suse"
    elif [ -r /lib/lsb/init-functions ]; then
        source /lib/lsb/init-functions
        [ zz$(type -t log_begin_msg 2>/dev/null) == "zzfunction" ] && dtype="debian"
    elif [ -r /etc/init.d/functions.sh ]; then
        source /etc/init.d/functions.sh
        [ zz$(type -t ebegin 2>/dev/null) == "zzfunction" ] && dtype="gentoo"
    elif [ -s /etc/mandriva-release ]; then
        dtype="mandriva"
    elif [ -s /etc/slackware-version ]; then
        dtype="slackware"
    elif [ -s /etc/arcg-release ]; then
        dtype="arch"
    fi
    echo $dtype
}

# Copy file with a progress bar
ccp() {
	rsync --info=progress2 "$@"
}

# Extracts any archive(s) (if unp isn't installed)
extract() {
    for archive in $*; do
        if [ -f $archive ]; then
            case $archive in
            *.tar.bz2) tar xvjf $archive ;;
            *.tar.gz) tar xvzf $archive ;;
            *.bz2) bunzip2 $archive ;;
            *.rar) rar x $archive ;;
            *.gz) gunzip $archive ;;
            *.tar) tar xvf $archive ;;
            *.tbz2) tar xvjf $archive ;;
            *.tgz) tar xvzf $archive ;;
            *.zip) unzip $archive ;;
            *.Z) uncompress $archive ;;
            *.7z) 7z x $archive ;;
            *) echo "don't know how to extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# Cd mktemp
cdtmp() {
    cd $(mktemp -d)
}

alias speed-test='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

add-to-set () {
    local setref=$1
    local newelm=$2
    local placetoadd=$3
    if ! echo "${!setref}" | /bin/grep -Eq "(^|:)${newelm}($|:)" ; then
        if [ -z "${!setref}" ] ; then
            read -d'' -r ${setref} <<< "${newelm}"
            return
        fi
        if [ "${placetoadd}" = "after" ] ; then
            read -d'' -r ${setref} <<< "${!setref}:${newelm}"
        else
            read -d'' -r ${setref} <<< "${newelm}:${!setref}"
        fi
    fi
}
