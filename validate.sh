#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  Validate script
#/ Option:       --help   - this command
#/ Option:       --update - update checksum, DON'T CALLED
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

FILE="sumfile.txt"

help() {
	local t="$PWD"
	cd "$(dirname "$1")"
	cat "validate.sh" | grep "^#/" | tr -d "#/"
	cd "$t"
}

shasum_command() {
	# shellcheck disable=SC2068
	command -v "shasum" &>/dev/null &&
		shasum $@ &&
		return 0

	# shellcheck disable=SC2068
	command -v "sha1sum" &>/dev/null &&
		sha1sum $@ &&
		return 0
}

validate() {
	local t="$PWD" file="resources/$FILE" exit_code=0
	cd "$(dirname "$1")" || exit 1
	shasum_command -c "$PWD/$file" || exit_code=$?
	cd "$t" || exit 1
	return "$exit_code"
}

update_resource() {
	local t="$PWD" file="resources/$FILE"
	cd "$(dirname "$1")" || exit 1
	shasum_command "$PWD/*[^txt]" >"$PWD/$file" 2>/dev/null
	{
		shasum_command "$PWD/**/*[^txt]"
		shasum_command "$PWD/**/**/*[^txt]"
		shasum_command "$PWD/**/**/**/*[^txt]"
	} >>"$PWD/$file" 2>/dev/null

	cd "$t" || exit 1
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

if [ "$1" == "update" ] ||
	[ "$1" == "--update" ] ||
	[ "$1" == "u" ] ||
	[ "$1" == "-u" ]; then
	update_resource "$0" && exit
fi

validate "$0"
