# This module contains some non essential functions

function bm-extract() {
    for archive in $*; do
        if [ -f ${archive} ]; then
            case ${archive} in
            *.tar.bz2) tar -xvjf "${archive}" ;;
            *.tar.gz) tar -xvzf "${archive}" ;;
            *.tar.xz) tar -xvzf "${archive}" ;;
            *.bz2) bunzip2 "${archive}" ;;
            *.rar) rar x "${archive}" ;;
            *.gz) gunzip "${archive}" ;;
            *.tar) tar xvf "${archive}" ;;
            *.tbz2) tar xvjf "${archive}" ;;
            *.tgz) tar xvzf "${archive}" ;;
            *.zip) unzip "${archive}" ;;
            *.Z) uncompress "${archive}" ;;
            *.7z) 7z x "${archive}" ;;
            *.rpm) rpm2cpio "${archive}" | bsdtar -xf - ;;
            *.xz) xz --decompress "${archive}" ;;
            *) echo "don't know how to extract '${archive}'..." ;;
            esac
        else
            echo "'${archive}' is not a valid file!"
        fi
    done
}

alias bm-cdtmp="cd $(mktemp -d)"
alias bm-speed-test='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'

function __bm-ping_loop() {
    local server="${1}"
    while :; do
        ping -c 1 "${server}" >/dev/null 2>&1
        local ret=$?
        if [ "${ret}" != "1" ]; then
            return ${ret}
        fi
    done
}

function bm-wait-for-ping() {
    local server="${1}"
    local ping_cancelled=false

    if [ -z "${server}" ]; then
        echo >2 "Host not specified"
        return 1
    fi

    __bm-ping_loop "${server}" &
    trap "kill -- $!; ping_cancelled=true" SIGINT
    wait $!
    local ret=$?
    trap - SIGINT
    return $ret
}

# bm-cowsay-img
# Cowsay something, then convert it to an image. Becuse why not?
function bm-cowsay-img() {
    local img="$1"
    if [ -z "$img" ]; then
        img="cowsay"
    fi
    local txt="$(fortune | cowsay)"
    local geometry=$(awk "BEGIN {printf \"%dx%d\", $(echo "$blah" | wc -L) * 7.2 + 80, $(echo "$blah" | wc -l)*16 + 80}")
    echo "$txt" | convert -page "$geometry" -font "Source-Code-Pro-Medium" text:- cowsay.jpg
}
