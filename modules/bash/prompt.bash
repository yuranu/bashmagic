# This module contains functions used to handle prompt events / generate
# PS1

# Functions specified in this hook will be invoked on prompt event, in the
# order of appearance. User may specify more functions
__bm_hook_prompt=""

# __bm-make-PS1
# Make some pretty looking PS1 variable
function __bm-make-PS1() {
    PS1=""
    # Python virtual env
    if [ "$VIRTUAL_ENV" ]; then
        PS1+="\[${bm_col_lightblue}\]($(basename ${VIRTUAL_ENV})) "
    fi
    # Username
    PS1+="\[${bm_col_yellow}\]\u"
    # SSH hostname
    if [ ! -z "${SSH_CLIENT}" ]; then
        PS1+="\[${bm_col_darkgray}\]@"
        PS1+="\[${bm_col_lightred}\]\h"
    fi
    # CWD
    PS1+="\[${bm_col_darkgray}\]:\[${bm_col_cyan}\]\w"
    # git branch
    local GIT_BRANCH=$(git branch 2>/dev/null | grep '* ' | cut -d ' ' -f2-)
    if [ "$GIT_BRANCH" ]; then
        PS1+="\[${bm_col_lightgreen}\][${GIT_BRANCH}]"
    fi
    if [[ $EUID -ne 0 ]]; then
        PS1+="\[${bm_col_green}\]>" # Normal user
    else
        PS1+="\[${bm_col_red}\]!!!>" # Root user
    fi
    PS1+="\[${bm_col_nocolor}\] "
}

# __bm-on-prompt
# This function is invoked before returning to prompt
function __bm-on-prompt() {
    IFS=":"
    for callback in ${__bm_hook_prompt}; do
        ${callback}
    done
}

bm-hook prompt __bm-make-PS1

bm-varappend PROMPT_COMMAND ';' __bm-on-prompt
