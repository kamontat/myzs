#!/usr/bin/env bash
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  1.1.0
# since:    21/04/2018

# error: 5    - file/folder not exist
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
export MYZS_TEMP_FILE="$MYZS_TEMP_FOLDER/temp"
export MYZS_LOG_FILE="$MYZS_TEMP_FOLDER/myzs.log"
export MYZS_ERROR_FILE="$MYZS_TEMP_FOLDER/myzs.error"

_print() {
	local date_char=15 head_char="${MYZS_HEADER_SIZE:-15}" nl="\n"
	local t="$1"
	shift
	local m="$*"
	test -z "$m" && nl=""
	printf "%-${date_char}s %${head_char}s - %s$nl" "$(date)" "$t" "$m"
}

# 1 - title
# 2 - message
if_debug_print() {
	[[ $MYZS_DEBUG_MODE != "debug" ]] &&
		[[ $MYZS_DEBUG_MODE != "full" ]] &&
		return 0

	_print "$@"
}

if_fully_debug_print() {
	[[ $MYZS_DEBUG_MODE != "full" ]] &&
		[[ $MYZS_DEBUG_MODE != "file" ]] &&
		return 0

	_print "$@" >>"${MYZS_LOG_FILE}"
}

if_full_debug_print() {
	if_fully_debug_print "$@"
}

if_debug_print_error() {
	if_debug_print "$@" >&2
}

if_fully_debug_print_error() {
	[[ $MYZS_DEBUG_MODE != "full" ]] &&
		return 0

	_print "$@" >>"${MYZS_ERROR_FILE}"
}

if_full_debug_print_error() {
	if_fully_debug_print_error "$@"
}

is_integer() {
	[[ $1 =~ ^[0-9]+$ ]] 2>/dev/null && return 0 || return 1
}

throw() {
	printf '%s\n' "$1" >&2 && is_integer "$2" && return "$2"
	return 0
}

list_myzs_env() {
	echo "$(env | grep "MYZS_")"
}

_load() {
	local file="$1" # temp

	! [ -f "$file" ] && if_debug_print_error "error" "file: ${file} NOT EXIST!"

	if source "$file" 2>>${MYZS_ERROR_FILE} 3>>${MYZS_LOG_FILE}; then
		# test -n "$temp" && echo "$temp"
		if_debug_print "load" "file: $file"
		return 0
	else
		if_debug_print_error "error" "file: $file"
		return 1
	fi
}

_loop_load() {
	local exit_code=0
	for f in $1/[0-9]*; do
		_load "$f" || ((exit_code++))
	done

	return $exit_code
}

load() {
	local folder="$1"
	! test -d "$folder" && throw "$folder Not EXIST!" && return 5
	_loop_load "$folder"
}

raw_load() {
	local folder="$1"
	! test -d "$folder" && echo "CANNOT load $folder" && return 199
	_loop_load "$folder"
}

SECONDS=0

raw_load "$MYZS_SETTING"

if_debug_print "load" "libraries"
raw_load "$MYZS_LIB"

if_debug_print "load" "global files"
load "$MYZS_GLOBAL"

if_debug_print "load" "oh-my-zsh custom setting files"
load "$MYZS_CUSTOM"

if_debug_print "load" "main script"
load "$MYZS_SRC"

duration=$SECONDS
min="$((duration / 60))"
sec="$((duration % 60))"

if_debug_print "STATUS" "--------------INSTALL COMPLETELY--------------"
if_debug_print "time" "$min minutes $sec seconds elapsed"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
