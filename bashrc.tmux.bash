#!/bin/bash

is_tmux() {
	if [ "ps -e | grep $(ps -o ppid= $$) | grep tmux" ]; then
		return 1
	fi
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
	if [ is_tmux ]; then
		tmux rename-window "$(ssh_cmd_hostname $@)"
		command ssh "$@"
		tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		command ssh "$@"
	fi
}

ipython() {
	if [ is_tmux ]; then
		tmux rename-window iPython
		command ipython "$@"
		tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		command ipython "$@"
	fi
}

notes() {
	if [ is_tmux ]; then
		tmux rename-window NOTES
		edit $NOTES_FILE
		tmux set-window-option automatic-rename "on" 1>/dev/null
	else
		edit $NOTES_FILE
	fi
}
