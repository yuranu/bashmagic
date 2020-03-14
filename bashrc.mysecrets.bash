if [ -z "$SECRETEXT" ]; then
    SECRETEXT="sec"
fi

mysecretsfile() {
    echo "$(cat ~/.mysecrets).${SECRETEXT}"
}

mysecrets() {
    if [ -f ~/.mysecrets ] && [ -f "$(mysecretsfile)" ]; then
        local pass
        read -sp $'Password:\n' pass
        { echo "${pass}" | gpg -d --batch --yes --passphrase-fd 0 "$(mysecretsfile)" 2> /dev/null; } || return $?
        echo;
    else
        echo "Invalid config (~/.mysecrets)"
        return 1
    fi
    return 0
}

mysecrets-edit() {
    if [ -f ~/.mysecrets ] && [ -f "$(mysecretsfile)" ]; then
        # Prepare working dir
        local tmpfile="$(TMPDIR=/dev/shm mktemp)" || return $?
        local tmpout="${tmpfile}.gpg"

        # Decrypt
        local pass
        read -sp $'Password:\n' pass
        { echo "${pass}" | gpg -d --batch --yes --passphrase-fd 0 "$(mysecretsfile)" > "${tmpfile}" 2> /dev/null; } || return $?

        # Edit
        edit ${tmpfile} || return $?

        # Re-encrypt
        { echo "${pass}" | gpg --batch --yes --passphrase-fd 0 --output ${tmpout} --symmetric ${tmpfile}; } || return $?
        cp $(mysecretsfile) "$(mysecretsfile).bak" || return $?
        mv ${tmpout} $(mysecretsfile) || return $?
    else
        echo "Invalid config (~/.mysecrets)"
        return 1
    fi
    return 0
}

mysecrets-token() {
	mysecrets | grep -oP --color=auto "(?<=${1} ).*"
}

