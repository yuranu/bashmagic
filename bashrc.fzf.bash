fzf-xdg-open() {
	local res=$(fzf)
	if [ ! -z "$res" ] ; then
		echo xdg-open "$res" $@
	fi
}

#bind '"\C-x": " \C-u`fzf-xdg-open`\n"'
bind  '"\C-x": " \C-e\C-u`fzf-xdg-open`\e\C-e\er\C-m"'
