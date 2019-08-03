export BASHMAGICDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"

update-bashmagic() {
    local PREV_DIR=$(pwd)
    cd $BASHMAGICDIR
    git pull
    cd "$PREV_DIR"
    source ~/.bashrc
}

for filename in $BASHMAGICDIR/bashrc.*.bash; do
    source ${filename}
done
