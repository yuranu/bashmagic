# Pacman
alias pacman-orphans='pacman -Qtdq'
alias pacman-fasttrack='sudo pacman-mirrors --fasttrack && sudo pacman -Syyu'

yay-clear-cache() {
	local yaycache="$(find ${HOME}/.cache/yay -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
	local yayremoved=$(/usr/bin/paccache -ruvk0 $yaycache | sed '/\.cache\/yay/!d' | cut -d \' -f2 | rev | cut -d / -f2- | rev)
	[ -z $yayremoved ] || echo "==> Remove all uninstalled package folders" &&
	echo $yayremoved | xargs -rt rm -r
	local yaycache="$(find ${HOME}/.cache/yay -maxdepth 1 -type d | awk '{ print "-c " $1 }' | tail -n +2)"
	echo "==> Keep last 2 installed versions"
	paccache -rvk2 -c /var/cache/pacman/pkg $yaycache
}
