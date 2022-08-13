# This is the entry point for bashmagic, should be sourced directly
# from .bashrc
# This file will load other bashmagic modules

# The below three functions cannot be in infra as they must be used to load
# infra

# bm-module-path
# print the full path of the currently sourced module to stdout
function bm-module-path() {
    echo $(realpath "${BASH_SOURCE[0]}")
    return 0
}

# bm-module-dir
# print the directory of the currently sourced module to stdout
function bm-module-dir() {
    echo $(dirname "$(bm-module-path)")
    return 0
}

# bm-module-name
# print the name of the currently sourced module to stdout
function bm-module-name() {
    echo $(basename "$(bm-module-path)")
    return 0
}

function __bm-main() {
    declare -a modules

    # This one provides functions used by other modules
    modules+=(infra.bash)

    # Non infra modules - add more here
    modules+=(prompt.bash)
    modules+=(hist.bash)
    modules+=(fzf.bash)
    modules+=(pacman.bash)
    modules+=(bat.bash)
    modules+=(vim.bash)
    modules+=(tmux.bash)
    modules+=(utils.bash)

    # This module can use any module above it, so it is wise to put it last
    modules+=(aliases.bash)

    local mydir=$(bm-module-dir)
    local module

    for module in "${modules[@]}"; do
        source "${mydir}/modules/bash/${module}"
    done
}

__bm-main
