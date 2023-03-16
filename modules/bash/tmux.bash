# This module contains some facny bells an whistles to integrate with TMUX

function __bm-is-tmux() {
    if ps -e | grep $(ps -o ppid= $$) | grep tmux >/dev/null 2>/dev/null; then
        return 0
    fi
    return 1
}

__bm-is-tmux || return

# bm-tmux-window-id
# Get current window ID based on TMUX_PANE
function bm-tmux-window-id() {
    tmux display -pt "${TMUX_PANE}" '#I'
}

# bm-tmux-window-name
# Get current window name based on TMUX_PANE
function bm-tmux-window-name() {
    tmux display -pt "${TMUX_PANE}" '#W'
}

# __bm-tmux-animate-window-name [DURATION]
# Flicker a window name for a few seconds to indicate some event
function __bm-tmux-animate-window-name() {
    local dur=$1
    if [ -z "$dur" ]; then
        dur=5
    fi

    local end="$(($SECONDS + $dur))"
    local name="$(bm-tmux-window-name)"
    local rename="${name}"
    local even=1

    local flicker="$(printf '%*s' "${#name}" | tr ' ' "+")"

    while [ "${SECONDS}" -lt "${end}" ]; do
        # Here is another point. While anminating, the name could have changed.
        # For example by user. Consider that.
        if [ "${rename}" != "$(bm-tmux-window-name)" ]; then
            name="$(bm-tmux-window-name)"
            flicker="$(printf '%*s' "${#name}" | tr ' ' "+")"
        fi

        if [ "$even" == "1" ]; then
            rename="${flicker}"
        else
            rename="${name}"
        fi

        tmux rename-window -t "$(bm-tmux-window-id)" "${rename}"

        if [ "${even}" == "1" ]; then
            sleep 1
        else
            sleep 0.5
        fi

        even="$((!${even}))"
    done
    tmux rename-window -t "$(bm-tmux-window-id)" "${name}"
}

declare -A __bm_last_pwd

# __bm-tmux-rename-based-on-cwd
# Prompt callback which will update the tmux window name based on the current
# directory
function __bm-tmux-rename-based-on-cwd() {

    # We have a prompt event arriving on some window, while the user may be
    # focused on a diffrent window right now. Keep that in mind.
    local active_wid="$(tmux display -p '#I')"
    local event_wid="$(bm-tmux-window-id)"

    local need_rename=false
    local need_indication=false

    if [ "${active_wid}" != "${event_wid}" ]; then
        need_rename=true
        need_indication=true
    else
        if [ "${__bm_last_pwd[${event_wid}]}" != "${PWD}" ]; then
            __bm_last_pwd[${event_wid}]="${PWD}"
            need_rename=true
        fi
    fi

    if "${need_rename}"; then
        local bname=$(basename "${PWD}")
        local rname=${bname:0:10}

        if [ "${bname}" != "${rname}" ]; then
            rname="${rname:0:9}~"
        fi
        tmux rename-window -t "$(bm-tmux-window-id)" "${rname}"
    fi

    if "${need_indication}"; then
        # So here is the story. The user launched some long running command,
        # then switched to a different window. Now the command is complete.
        # User does not see this. We should give him some indication it did.
        # Make the window name flicker or something, IDK.
        (__bm-tmux-animate-window-name &)
    fi
}

tmux set-window-option -t "$(bm-tmux-window-id)" automatic-rename "off"
bm-hook prompt __bm-tmux-rename-based-on-cwd

# bm-multi-ssh LIST_OF_SSH_NODES
# Split tmux pane into horizontal windows, in each open ssh connection to one
# of the given nodes
function bm-multi-ssh() {
    if [ "$#" -lt 2 ]; then
        echo >&2 "Error: At least 2 nodes are required."
        return 1
    fi

    local first=$1
    shift

    for var in "$@"; do
        tmux split-window -v ssh "${var}"
    done

    tmux select-layout even-vertical
    tmux setw synchronize-panes

    # Clear screen

    tmux send-keys C-l
    tmux send-keys -R
    tmux clear-history

    ssh "${first}"

    return 0
}

# bm-tmux-open-layout LAYOUT
# A quick way to split the screen into a pre defined layout
# Possible layouts are 2x3 2x2 3x3
function bm-tmux-open-layout() {
	case $1 in
		2x3)
			tmux new-window
			tmux split-window -h
			tmux split-window -h
			tmux select-layout even-horizontal
			tmux split-window -v
			tmux select-pane -t 1
			tmux split-window -v
			tmux select-pane -t 0
			tmux split-window -v
			tmux select-pane -t 0
		;;
		2x2)
			tmux new-window
			tmux split-window -h
			tmux split-window -v
			tmux select-pane -t 0
			tmux split-window -v
			tmux select-pane -t 0
		;;
		3x3)
			tmux new-window
			tmux split-window -h
			tmux split-window -h
			tmux split-window -v
			tmux split-window -v
			tmux select-pane -t 1
			tmux split-window -v
			tmux split-window -v
			tmux select-pane -t 0
			tmux split-window -v
			tmux split-window -v
			tmux select-pane -t 0
			tmux select-layout tiled
		;;
		*)
			>&2 echo "Invalid layout <$1>"
	esac
}

complete -W "2x3 2x2 3x3" bm-tmux-open-layout

function bm-tmux-broadcast-command() {
    tmux list-panes -s -F '#{session_name}:#{window_index}.#{pane_index} #{pane_pid}' | while read line ; do
        local pane=`echo ${line} | cut -d' ' -f1`
	local pid=`echo ${line} | cut -d' ' -f2`
	local cmdline=`tr -d '\0' < /proc/${pid}/cmdline`
        if ! pgrep -P "${pid}" 2>&1 >/dev/null && [[ "${cmdline}" == *bash* ]]; then
            tmux send-keys -t "${pane}" C-c
            tmux send-keys -t "${pane}" Home C-k "$*" Enter
        fi
    done
}


# TODO: decide what to do with that legacy stuff. I am not sure I want to throw
# it away. May be useful.

# ssh_cmd_hostname() {
#     local SSH_FLAGS=46AaCfGgKkMNnqsTtVvXxYy
#     local DEST_HOSTNAME='ssh'
#     for ((i = 1; i <= $#; i++)); do
#         var=${!i}
#         if [[ "$var" == -* ]]; then
#             local flag=${var:1}
#             if [[ ! "$SSH_FLAGS" == *"$flag"* ]]; then
#                 ((i++))
#             fi
#         else
#             DEST_HOSTNAME="$var"
#             break
#         fi
#     done

#     DEST_HOSTNAME=$(echo "$DEST_HOSTNAME" | grep -Po '.*@\K.*|.*')

#     if [ -z "$DEST_HOSTNAME" ]; then
#         DEST_HOSTNAME=ssh
#     fi

#     echo $DEST_HOSTNAME
# }

# ssh() {
#     if [ -z $SSH ]; then
#         local SSH=ssh
#     fi
#     if is_tmux; then
#         tmux rename-window "(ssh)$(ssh_cmd_hostname $@)"
#         command $SSH "$@"
#         local __EXIT_CODE=$?
#         tmux set-window-option automatic-rename "on" 1>/dev/null
#         return $__EXIT_CODE
#     else
#         command $SSH "$@"
#     fi
# }
