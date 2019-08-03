#!/bin/bash

is_tmux() {
	if [ "ps -e | grep $(ps -o ppid= $$) | grep tmux" ]; then
		return 1
	fi
	return 0
}

ssh() {
	if [ is_tmux ]; then
		tmux rename-window "$(echo $* | cut -d . -f 1)"
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