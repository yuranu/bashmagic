#!/bin/bash

is_tmux() {
	if [ "ps -e | grep $(ps -o ppid= $$) | grep tmux" ]; then
		return 1
	fi
	return 0
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
	if [ is_tmux ]; then
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
	if [ is_tmux ]; then
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
	if [ is_tmux ]; then
		tmux rename-window NOTES
		edit $NOTES_FILE
		local __EXIT_CODE=$?
		tmux set-window-option automatic-rename "on" 1>/dev/null
		return $__EXIT_CODE
	else
		edit $NOTES_FILE
	fi
}
