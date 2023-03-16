# This modules contains practical tricks done in a 'non clean' way relying
# on some ondocumented / unofficial behaviours.

function bm-inject-var() {
    local pid=$1
    shift
    [ -z "$pid" ] && >&2 echo "PID not specified" && return 1
    local varname=$1
    [ -z "$varname" ] && >&2 echo "Variable name not specified" && return 1
    shift
    local varval="$@"
    echo "call (int) setenv (\"${varname}\", \"${varval}\", 1)" | >/dev/null 2>&1 sudo gdb -p "${pid}"
}
