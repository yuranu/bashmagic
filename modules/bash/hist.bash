# This module contains some enhancements to the bash history.
# Must be loaded after prompt.

# Source: https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
export HISTCONTROL=ignoredups:erasedups # no duplicate entries
export HISTSIZE=100000                  # big big history
export HISTFILESIZE=100000              # big big history
shopt -s histappend              # append to history, don't overwrite it

# __bm-hist-save-reload
# Save and reload the history after each command finishes
function __bm-hist-save-reload() {
    history -a
}

bm-hook prompt __bm-hist-save-reload
