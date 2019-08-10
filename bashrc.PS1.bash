make_PS1() {
    PS1=""
	# Python virtual env
	if [ "$VIRTUAL_ENV" ]; then
		PS1+="\[${COL_LIGHTBLUE}\]($(basename ${VIRTUAL_ENV})) "
	fi
    # Username
    PS1+="\[${COL_YELLOW}\]\u"
    # CWD
    PS1+="\[${COL_DARKGRAY}\]:\[${COL_CYAN}\]\w"
    # git branch
    local GIT_BRANCH=$(git branch 2>/dev/null | grep '* ' | cut -d ' ' -f2-)
    if [ "$GIT_BRANCH" ]; then
        PS1+="\[${COL_LIGHTGREEN}\][${GIT_BRANCH}]"
    fi
    if [[ $EUID -ne 0 ]]; then
        PS1+="\[${COL_GREEN}\]>" # Normal user
    else
        PS1+="\[${COL_RED}\]!!!>" # Root user
    fi
	PS1+="\[${COL_NOCOLOR}\] "
}

PROMPT_COMMAND=make_PS1
