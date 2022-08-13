# This module contains some useful shortcuts for pacman package manager,
# together with its extensions such as yay, if available

bm-command-defined fzf || return

alias bm-pacman-orphans='pacman -Qtdq'
alias bm-pacman-fasttrack='sudo pacman-mirrors --fasttrack && sudo pacman -Syyu'

if bm-command-defined yay; then
    # yay specific extenstions

    # bm-yay-clear-cache [KEEPLAST=2]
    # Clear packages cache, leaving KEEPLAST items for each package
    function bm-yay-clear-cache() {
        local keeplast="$1"
        if [ -z "${keeplast}" ]; then
            keeplast=2
        fi
        if ! [[ "${keeplast}" =~ ^[1-9][0-9]*$ ]]; then
            echo "Invalid input keeplast=${keeplast}" 2>&1
            return 127
        fi
        local yaycache="$(find ${HOME}/.cache/yay -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
        local yayremoved=$(/usr/bin/paccache -ruvk0 $yaycache | sed '/\.cache\/yay/!d' | cut -d \' -f2 | rev | cut -d / -f2- | rev)
        [ -z $yayremoved ] || echo "==> Remove all uninstalled package folders" &&
            echo $yayremoved | xargs -rt rm -r
        local yaycache="$(find ${HOME}/.cache/yay -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
        echo "==> Keep last ${keeplast} installed versions"
        paccache -rvk${keeplast} -c /var/cache/pacman/pkg $yaycache
    }

fi
