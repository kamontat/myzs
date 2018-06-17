#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  Install script
#/               To install script,
#/                 1. This will verify by validate checksum
#/                 2. This will copy this project to
#/                    $HOME/.myzs/ folder, this will fail if directory is exist
#/                 3. create symlink between '$HOME/.myzs/.zshrc' and '$HOME/.zshrc'
#/                    this will fail if file exist
#/ Create by:    Kamontat Chantrachirathumrong
#/ Since:        27/03/2018
#/ -------------------------------------------------
#/ Version:      0.0.1  -- add help command
#/               1.0.0  -- production
#/ -------------------------------------------------
#/ Error code    1      -- common error
#/ -------------------------------------------------
#/ Known bug:    not exist
#/ -------------------------------------------------

help() {
	local t="$PWD"
	cd "$(dirname "$0")" || return 1
	cat "install.sh" | grep "^#/" | tr -d "#/"
	cd "$t" || return 1
}

validate() {
	local t="$PWD" exit_code=0
	cd "$(dirname "$0")" || return 1
	"$PWD/validate.sh" >/tmp/myzs/install.log 2>/dev/null || exit_code=$?
	cd "$t" || return 1
	return $exit_code
}

create_link() {
	local t="$PWD" exit_code=0
	cd "$1" || return 1
	ln -s "${HOME}/.myzs/.zshrc" "$HOME/.zshrc" || exit_code=$?
	cd "$t" || return 1
	return $exit_code
}

# -------------------------------------------------
# Constants
# -------------------------------------------------

if [ "$1" == "help" ] ||
	[ "$1" == "--help" ] ||
	[ "$1" == "h" ] ||
	[ "$1" == "-h" ] ||
	[ "$1" == "?" ] ||
	[ "$1" == "-?" ]; then
	help "$0" && exit
fi

dir="$HOME/.myzs"
zshrc="$HOME/.zshrc"

printf "cloning.."
if test -d "$dir"; then
	echo " -> directory ($dir) exist"
	exit 5
else 
	mkdir "$dir" || exit 6
	cp -r . "$dir" || exit 7
	echo " -> complete"
fi

printf "creating link.."
if test -f "$zshrc" || test -L "$zshrc"; then
	echo " -> zshrc ($zshrc) exist"
	exit 10
else 
	create_link "$HOME" || exit 11
	echo " -> complete"
fi

printf "validating.. (BY CHECKSUM)"
validate && echo " -> complete" || echo " -> exit by $?"

echo "LOG FILE: /tmp/myzs/install.log"
