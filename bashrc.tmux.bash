#!/bin/bash

tmux-rename-based-on-cwd() {
	if [ "${BASHMAGIC_TMUX_RENAME}" == "on" ] && is_tmux ; then
		if [ "${__LAST_PROMPT_PWD}" == "${PWD}" ]; then
			return 0
		else
			export __LAST_PROMPT_PWD=${PWD}
		fi
		if [ ! -z "${BASHMAGIC_TMUX_RENAME_HOOK}" ] ; then
			local hook_arr
			local hook
			local rname
			IFS=':' read -r -a hook_arr <<< "${BASHMAGIC_TMUX_RENAME_HOOK}"
			for hook in "${hook_arr[@]}" ; do
				if [ ! -z "${hook}" ] ; then
					rname="${rname}$(${hook})"
				fi
			done
			if [ ! -z "${rname}" ]; then
				tmux set-window-option -t "$(tmux-window-id)" automatic-rename-format "${rname}"
				if [ "$(tmux-window-id)" != $(tmux display -p '#I') ] ; then
					(tmux-animate-window-name &)
				fi
				return 0
			fi
		fi
		local bname=$(basename "$(pwd)")
		local rname=${bname:0:10}

		if [ "${bname}" != "${rname}" ]; then
			rname="${rname:0:9}~"
		fi
		tmux set-window-option -t "$(tmux-window-id)" automatic-rename-format "${rname}"
		if [ "$(tmux-window-id)" != $(tmux display -p '#I') ] ; then
			(tmux-animate-window-name &)
		fi
	fi
	return 0
}

tmux-window-id() {
	tmux display -pt "${TMUX_PANE}" '#I'
}

tmux-window-name() {
	tmux display -pt "${TMUX_PANE}" '#W'
}

tmux-animate-window-name() {
	local len=$1
	if [ -z "$len" ] ; then
		len=10
	fi
	local end=$(($SECONDS+$len))
	local i sp n
	sp='#*0 '
	n=${#sp}
	local ininame=$(tmux-window-name)
	local name=$ininame
	local rename
	local ch
	while [ $SECONDS -lt $end ]; do
		ch="${sp:i++%n:1}"
		rename="${ch}${name:1:-1}${ch}"
		if [ "$rename" != "$(tmux-window-name)" ] ; then
			name="$(tmux-window-name)"
		fi
		tmux rename-window -t "$(tmux-window-id)" "${rename}"
		sleep 0.2
    done
	tmux set-window-option automatic-rename "on"
}

is_tmux() {
	if ps -e | grep $(ps -o ppid= $$) | grep tmux >/dev/null 2>/dev/null; then
		return 0
	fi
	return 1
}

## Split tmux pane into horizontal windows, in each open ssh connection to one of given nodes
## @param $@ list of nodes
multi-ssh() {
	if [ "$#" -lt 2 ]; then
		>&2 echo "Error: At least 2 nodes are required."
		return 1
	fi
	
	local first=$1
	shift
	
	for var in "$@"; do
		tmux split-window -v ssh $var
	done
	
	tmux select-layout even-vertical
	tmux setw synchronize-panes

	# Clear screen

	tmux send-keys C-l
	tmux send-keys -R
	tmux clear-history

	ssh $first
	
	return 0
}

ssh_cmd_hostname() {
	local SSH_FLAGS=46AaCfGgKkMNnqsTtVvXxYy
	local DEST_HOSTNAME='ssh'
	for ((i=1; i <= $#; i++)); do
		var=${!i}
    	if [[ "$var" == -* ]]; then
			local flag=${var:1}
			if [[ ! "$SSH_FLAGS" == *"$flag"* ]]; then
				((i++))
			fi
		else
			DEST_HOSTNAME="$var"
			break
		fi
	done

	DEST_HOSTNAME=$(echo "$DEST_HOSTNAME" | grep -Po '.*@\K.*|.*')

	if [ -z "$DEST_HOSTNAME" ]; then
		DEST_HOSTNAME=ssh
	fi

	echo $DEST_HOSTNAME
}

ssh() {
	if is_tmux; then
		tmux rename-window "$(ssh_cmd_hostname $@)"
		command ssh "$@"
		local __EXIT_CODE=$?
		tmux set-window-option automatic-rename "on" 1>/dev/null
		return $__EXIT_CODE
	else
		command ssh "$@"
	fi
}

ipython() {
	if is_tmux; then
		tmux rename-window iPython
		command ipython "$@"
		local __EXIT_CODE=$?
		tmux set-window-option automatic-rename "on" 1>/dev/null
		return $__EXIT_CODE
	else
		command ipython "$@"
	fi
}

notes() {
	if is_tmux; then
		tmux rename-window NOTES
		edit $NOTES_FILE
		local __EXIT_CODE=$?
		tmux set-window-option automatic-rename "on" 1>/dev/null
		return $__EXIT_CODE
	else
		edit $NOTES_FILE
	fi
}

export PROMPT_COMMAND="tmux-rename-based-on-cwd;${PROMPT_COMMAND}"
