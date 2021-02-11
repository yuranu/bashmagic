#!/bin/bash

export LESS='--mouse --wheel-lines=3 -# 4'

alias la='ls -lah'
alias ll='ls -Fls'

alias edit='vim'
alias ebrc='vim ~/.bashrc'
alias cls='clear'

vimlg() {
	vim -R -M "$1" -c 'setfiletype log'
}

# Fuzzy find history - refresh it first
#alias __fzf_history__='history -r && __fzf_history__'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'

# Alias's for multiple directory listing commands
alias la='ls -Alh' # show hidden files
alias ls='ls -aFh --color=always' # add colors and file type extensions
alias lx='ls -lXBh' # sort by extension
alias lk='ls -lSrh' # sort by size
alias lc='ls -lcrh' # sort by change time
alias lu='ls -lurh' # sort by access time
alias lr='ls -lRh' # recursive ls
alias lt='ls -ltrh' # sort by date
alias lm='ls -alh |more' # pipe through 'more'
alias lw='ls -xAh' # wide listing format
alias ll='ls -Fls' # long listing format
alias labc='ls -lap' #alphabetical sort
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search running processes
alias p="ps aux | grep "
alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"

alias cpuusage="top -bn1 | grep 'Cpu(s)' | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print 100 - \$1\"%\"}'"

alias vless=/usr/share/vim/vim82/macros/less.sh

alias rsync='rsync -a --info=progress2'


if command -v bat >/dev/null 2>&1 ; then
	export MANPAGER="bash -c 'col -b | bat -l man -p'"
	alias linux-doc-fzf="find /usr/share/doc/linux/ -name '*.rst' -o -name '*.txt' | xargs -I {} bash -c \"cat -b {} | grep -P '\w' | sed 's|^|{}: |'\" | fzf | sed -E 's/^([^:]*):\s*([0-9]*).*/\1 --pager \"less -R +\2\"/' | xargs bat -l rst"
fi

function csv-read() {
	if [ -z "$1" ]; then
		echo "Usage: csv-read CSV_FILE_NAME"
		return 1
	fi
	column '-o | ' -s, -t < "$1" | bat -l csv --file-name "$1"
}
