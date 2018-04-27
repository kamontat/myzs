#!/usr/bin/env bash
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  1.1.0
# since:    21/04/2018

# error: 5    - file/folder not exist
#        10   - variable not exist
#        199  - raw error

# set -x # DEBUG

export MYZS_ROOT="${HOME}/.myzs"
export MYZS_SRC="${HOME}/.myzs/src"

export MYZS_GLOBAL="${MYZS_ROOT}/global"

export MYZS_SETTING="${MYZS_GLOBAL}/settings"
export MYZS_LIB="${MYZS_GLOBAL}/lib"

export MYZS_CUSTOM="${MYZS_ROOT}/custom.lib"

export MYZS_TEMP_FOLDER="/tmp/myzs"
mkdir $MYZS_TEMP_FOLDER &>/dev/null

_myzs_is_integer() {
	[[ $1 =~ ^[0-9]+$ ]] 2>/dev/null && return 0 || return 1
}

throw() {
	printf '%s\n' "$1" >&2 && _myzs_is_integer "$2" && return "$2"
	return 0
}

_myzs_list_myzs_env() {
	_myzs_get_env_value | grep "MYZS_"
}

_myzs__load() {
	local file="$1" # temp

	! [ -f "$file" ] && _myzs_if_debug_print_error "error" "file: ${file} NOT EXIST!"

	if source "$file" 2>>${MYZS_ERROR_FILE} 3>>${MYZS_LOG_FILE}; then
		# test -n "$temp" && echo "$temp"
		_myzs_if_debug_print "load" "file: $file"
		return 0
	else
		_myzs_if_debug_print_error "error" "file: $file"
		return 1
	fi
}

_myzs_loop_load() {
	local exit_code=0
	for f in $1/[0-9]*; do
		_myzs__load "$f" || ((exit_code++))
	done

	return $exit_code
}

_myzs_load() {
	local folder="$1"
	! test -d "$folder" && throw "$folder Not EXIST!" && return 5
	_myzs_loop_load "$folder"
}

_myzs_raw_load() {
	local folder="$1"
	! test -d "$folder" && echo "CANNOT load $folder" && return 199
	_myzs_loop_load "$folder"
}

SECONDS=0

# _myzs_if_debug_print "load" "libraries"
_myzs_raw_load "$MYZS_LIB"

_myzs_raw_load "$MYZS_SETTING"

_myzs_if_debug_print "load" "global files"
_myzs_load "$MYZS_GLOBAL"

_myzs_if_debug_print "load" "oh-my-zsh custom setting files"
_myzs_load "$MYZS_CUSTOM"

_myzs_if_debug_print "load" "main script"
_myzs_load "$MYZS_SRC"

duration=$SECONDS
min="$((duration / 60))"
sec="$((duration % 60))"

_myzs_if_debug_print "STATUS" "--------------INSTALL COMPLETELY--------------"
_myzs_if_debug_print "time" "$min minutes $sec seconds elapsed"
_myzs_if_full_debug_print "time" "$min minutes $sec seconds elapsed"
