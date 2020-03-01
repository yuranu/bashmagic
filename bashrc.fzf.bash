fzf-xdg-open() {
	local res=$(fzf)
	if [ ! -z "$res" ] ; then
		xdg-open "$res" $@
		return $?
	else
		return 1
	fi
}

bind '"\C-x": " \C-ufzf-xdg-open\n"'
