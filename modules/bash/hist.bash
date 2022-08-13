# This module contains some enhancements to the bash history.
# Must be loaded after prompt.

# Source: https://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
HISTCONTROL=ignoredups:erasedups # no duplicate entries
HISTSIZE=100000                  # big big history
HISTFILESIZE=100000              # big big history
shopt -s histappend              # append to history, don't overwrite it

# __bm-hist-save-reload
# Save and reload the history after each command finishes
function __bm-hist-save-reload() {
    history -n
    history -w
    history -c
    history -r
}

bm-hook prompt __bm-hist-save-reload
