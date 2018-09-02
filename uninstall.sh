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

help() {
	grep "^#/" <"uninstall.sh" | tr -d "#/ "
}

delete() {
	local f="$1"
	rm -rf "$f" 2>/dev/null
}

# -------------------------------------------------
# App logic
# -------------------------------------------------

cd "$(dirname "$0")" || exit 1

if [ "$1" == "help" ] ||
	[ "$1" == "--help" ] ||
	[ "$1" == "h" ] ||
	[ "$1" == "-h" ] ||
	[ "$1" == "?" ] ||
	[ "$1" == "-?" ]; then
	help "$0" && exit
fi

source "./progress.sh" || exit 2

progressbar delete "Delete" "${HOME}/.zshrc" "${HOME}/.myzs"
