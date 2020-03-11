export BASHMAGICDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
export PROMPT_COMMAND=

update-bashmagic() {
    local PREV_DIR=$(pwd)
    cd $BASHMAGICDIR
    git pull
    cd "$PREV_DIR"
}

for filename in $BASHMAGICDIR/bashrc.*.bash; do
	if [[ -z "${BASHMAGIC_EXCLUDE}" || ! ${filename} =~ ${BASHMAGIC_EXCLUDE} ]] ; then
		source "${filename}"
	fi
done
