#!/bin/bash
set -euo pipefail

pw1=""
pw2=""

file=$1
test -f ${file}
test "${file: -4}" == ".gpg"

dest="${file:: -4}".asc

gpg -q --no-tty -d --passphrase "$pw1" -o- ${file} \
  | gpg -q -c --passphrase "$pw2" --cipher-algo AES256 -a -o $dest

ug=$(stat -c '%U:%G' ${file})
perms=$(stat -c '%a' ${file})
chown ${ug} ${dest}
chmod ${perms} ${dest}

one="$(gpg -q --no-tty -d --passphrase "${pw1}" -o- ${file} | md5sum)"
two="$(gpg -q --no-tty -d --passphrase "${pw2}" -o- ${dest} | md5sum)"

test "${one}" == "${two}"

rm $file

echo "done: ${file} -> ${dest}"
