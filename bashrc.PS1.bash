make_PS1() {
    PS1=""
    # Username
    PS1+="\[${COL_YELLOW}\]\u"
    # CWD
    PS1+="\[${COL_DARKGRAY}\]:\[${COL_CYAN}\]\w"
    # git branch
    local GIT_BRANCH=$(git branch 2>/dev/null | head -n 1 | cut -d ' ' -f2-)
    if [ "$GIT_BRANCH" ]; then
        PS1+="\[${COL_LIGHTGREEN}\][${GIT_BRANCH}]"
    fi
    if [[ $EUID -ne 0 ]]; then
        PS1+="\[${COL_GREEN}\]>\[${COL_NOCOLOR}\] " # Normal user
    else
        PS1+="\[${COL_RED}\]!!!>\[${COL_NOCOLOR}\] " # Root user
    fi
}
