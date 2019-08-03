if [ -z "$SECRETEXT" ]; then
    SECRETEXT="banana"
fi

mysecretsfile() {
    echo "$(cat ~/.mysecrets).${SECRETEXT}"
}

mysecrets() {
    if [ -f ~/.mysecrets ] && [ -f "$(mysecretsfile)" ]; then
        gpg -d $(mysecretsfile) 2> /dev/null || return $?
        echo
    else
        echo "Invalid config (~/.mysecrets)"
        return 1
    fi
    return 0
}

editsecrest() {
    if [ -f ~/.mysecrets ]; then
        TMPFILE=$(TMPDIR=/dev/shm mktemp) || return $?
        TMPOUT="$TMPFILE.gpg"
        trap "rm -rf $TMPOUT $TMPFILE" EXIT
        mysecrets >"$TMPFILE" || return $?
        vi $TMPFILE || return $?
        gpg --output $TMPOUT --symmetric $TMPFILE || return $?
        cp $(mysecretsfile) "$(mysecretsfile).bak" || return $?
        mv $TMPOUT $(mysecretsfile) || return $?
        return 0
    else
        echo "Secrets file not found"
        return 1
    fi

}
