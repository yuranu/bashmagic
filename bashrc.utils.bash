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

get-distro() {
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
    elif [ -e /etc/mandriva-release ]; then
        dtype="mandriva"
    elif [ -e /etc/slackware-version ]; then
        dtype="slackware"
    elif [ -e /etc/arch-release ]; then
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
            *.tar.bz2) tar xvjf "$archive" ;;
            *.tar.gz) tar xvzf "$archive" ;;
            *.bz2) bunzip2 "$archive" ;;
            *.rar) rar x "$archive" ;;
            *.gz) gunzip "$archive" ;;
            *.tar) tar xvf "$archive" ;;
            *.tbz2) tar xvjf "$archive" ;;
            *.tgz) tar xvzf "$archive" ;;
            *.zip) unzip "$archive" ;;
            *.Z) uncompress "$archive" ;;
            *.7z) 7z x "$archive" ;;
            *.rpm) rpm2cpio "$archive" | bsdtar -xf - ;;
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

__ping_loop() {
	local server="${1}"
	while : ; do
		ping -c 1 "${server}"
		local ret=$?
		if [ "${ret}" != "1" ]; then
			return ${ret}
		fi
	done
}

wait-for-ping() {
	local server="${1}"
	local ping_cancelled=false

	if [ -z "${server}" ]; then
		>2 echo "Host not specified"
		return 1
	fi

	__ping_loop "${server}" &
	trap "kill -- $!; ping_cancelled=true" SIGINT
	wait $!
	local ret=$?
	trap - SIGINT
	return $ret
}

notify-on-ping() {
	for srv in "$@"; do
		wait-for-ping "$srv" || return $?
	done
	zenity --info --text="Have ping to '$*'"
}

string-replace() {
    local str="$1"
    local rep="$2"
    local off="$3"
    echo "${str:0:${off}}${rep}${str:$((${off}+${#rep}))}"
}


function cheatsheet() {
	if [ -z "$BASHMAGIC_CHEATSHEET_FILE" ] ; then
		>&2 echo BASHMAGIC_CHEATSHEET_FILE not set
		return 1
	fi
	if [ "$1" == "-i" ]; then
		edit "$BASHMAGIC_CHEATSHEET_FILE"
		return $?
	fi
	if type bat 2> /dev/null; then
		bat --style header "$BASHMAGIC_CHEATSHEET_FILE"
	else
		less "$BASHMAGIC_CHEATSHEET_FILE"
	fi
}

present() {
	vim -M "$@" -c PresentingStart -c Goyo
}

string-ring-replace() {
    local str="$1"
    local rep="$2"

    if [ "${#str}" -lt "${#rep}" ]; then
        local dif="$(("${#rep}" - "${#str}"))"
        IFS= str="${str}$(printf '%*s' ${dif})"
    fi

    local off=$(("$3" % "${#str}"))

    local len_e=$((${#str} - ${off}))
    if [ "${len_e}" -lt "0" ] ; then
        len_e="0"
    fi
    if [ "${len_e}" -gt "${#rep}" ] ; then
        len_e="${#rep}"
    fi

    IFS= str=$(string-replace "${str}" "${rep:${len_e}}" "0")
    IFS= str=$(string-replace "${str}" "${rep:0:${len_e}}" "${off}")

    echo -n "${str}"
}

cowsay-img() {
    local img="$1"
    if [ -z "$img" ]; then
        img="cowsay"
    fi
    local txt="$(fortune|cowsay)"
    local geometry=$(awk "BEGIN {printf \"%dx%d\", $(echo "$blah" | wc -L) * 7.2 + 80, $(echo "$blah" | wc -l)*16 + 80}")
    echo "$txt" | convert -page "$geometry" -font "Source-Code-Pro-Medium" text:- cowsay.jpg
}

