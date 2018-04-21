#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  Uninstall myzs setting from $HOME
#/ Create by:    Kamontat Chantrachirathumrong
#/ Since:        17/04/2018
#/ -------------------------------------------------
#/ Version:      1.0.0  -- Uninstall script
#/ -------------------------------------------------
#/ Error code    1      -- error
#/ -------------------------------------------------

cd "$(dirname "$0")" || exit 1
# cd "$(dirname "$(realpath "$0")")"

help() {
	grep "^#/" <"uninstall.sh" | tr -d "#/ "
}

# -------------------------------------------------
# App logic
# -------------------------------------------------

if [ "$1" == "help" ] ||
	[ "$1" == "--help" ] ||
	[ "$1" == "h" ] ||
	[ "$1" == "-h" ] ||
	[ "$1" == "?" ] ||
	[ "$1" == "-?" ]; then
	help "$0" && exit
fi

printf ".myzs have been   "

if test -d "${HOME}/.myzs"; then
	rm -rf "${HOME}/.myzs" &&
		echo "DELETED!" ||
		echo "ERROR!"
else
	echo "NOT EXIST"
fi

printf ".zshrc have been  "

if test -f "${HOME}/.zshrc" ||
	test -h "${HOME}/.zshrc"; then
	rm -rf "${HOME}/.zshrc" &&
		echo "DELETED!" ||
		echo "ERROR!"
else
	echo "NOT EXIST"
fi
