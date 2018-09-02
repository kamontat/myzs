# shellcheck disable=SC1090,SC2148

# maintain: Kamontat Chantrachirathumrong
# version:  1.1.0
# since:    21/04/2018

# error: 2    - wrong call function or method
#        5    - file/folder not exist
#        10   - variable not exist
#        199  - raw error

ROOT="${HOME}/.zshrc"
[ -h "$ROOT" ] && ROOT="$(readlink "$ROOT")"
ROOT="$(dirname "$ROOT")"

export MYZS_ROOT="$ROOT"
export MYZS_LIB="${MYZS_ROOT}/lib"
export MYZS_SRC="${MYZS_ROOT}/src"

source "${MYZS_LIB}/constrants.sh"
source "${MYZS_LIB}/helper.sh"

source "${MYZS_SRC}/default.variable.sh"
source "${MYZS_LIB}/progress.sh"

pg_start
source "${MYZS_LIB}/lazyload.sh"

pg_mark "Load require libraries"
source "${MYZS_LIB}/setup.sh" || pg_mark_false "Loading setup file"

pg_mark "Setup variables"
source "${MYZS_SRC}/custom.variable.sh" || pg_mark_false "Setting custom variable"

pg_mark "Setup alias"
source "${MYZS_SRC}/default.alias.sh" || pg_mark_false "Loading default alias"
source "${MYZS_SRC}/custom.alias.sh" || pg_mark_false "Loading custom alias"

pg_mark "Setup libraries"
source "${MYZS_SRC}/default.library.sh" || pg_mark_false "Loading default library"

pg_mark "Setup completions"
source "${MYZS_SRC}/default.completion.sh" || pg_mark_false "Loading default completion"

pg_mark "Setup work location"
source "${MYZS_SRC}/location.sh" || pg_mark_false "Loading location cli"

pg_mark "Setup zgen"
if is_string_exist "$ZGEN_HOME" && is_file_exist "${ZGEN_HOME}/zgen.zsh"; then
	source "${MYZS_SRC}/zgen.zsh"
	source "${ZGEN_HOME}/zgen.zsh"

	if ! zgen saved || $ZGEN_FORCE_SAVE; then
		# prezto options
		zgen prezto editor key-bindings 'emacs'
		zgen prezto prompt theme 'steeef'

		zgen prezto

		for plugin in "${ZGEN_PREZTO_PLUGIN_LIST[@]}"; do
			zgen prezto "$plugin"
		done

		for plugin in "${ZGEN_PLUGIN_LIST[@]}"; do
			zgen load "$plugin"
		done

		# generate the init script from plugins above
		zgen save
	fi

	# https://github.com/hlissner/zsh-autopair#zgen--prezto-compatibility
	autopair-init
else
	pg_mark_false "Zgen not found"
fi

pg_stop

# SECONDS=0

# export MYZS_ROOT="${HOME}/.myzs"
# export MYZS_SRC="${HOME}/.myzs/src"

# export MYZS_GLOBAL="${MYZS_ROOT}/global"

# export MYZS_SETTING="${MYZS_GLOBAL}/settings"
# export MYZS_LIB="${MYZS_GLOBAL}/lib"

# export MYZS_CUSTOM="${MYZS_ROOT}/custom.lib"

# export MYZS_TEMP_FOLDER="/tmp/myzs"
# mkdir $MYZS_TEMP_FOLDER &>/dev/null

# _myzs_is_integer() {
# 	[[ $1 =~ ^[0-9]+$ ]] 2>/dev/null && return 0 || return 1
# }

# throw() {
# 	printf '%s\n' "$1" >&2 && _myzs_is_integer "$2" && return "$2"
# 	return 0
# }

# _myzs__load() {
# 	local file="$1" # temp

# 	! [ -f "$file" ] && _myzs_print_error_tofile "status" "file" "${file} NOT EXIST!"

# 	if source "$file"; then
# 		_myzs_print_log_tostd "load" "file" "${file}"
# 		return 0
# 	else
# 		_myzs_print_error_tostd "load" "file" "${file} (code=$?)"
# 		return 1
# 	fi
# }

# _myzs_loop_load() {
# 	local exit_code=0
# 	for f in $1/[0-9]*; do
# 		_myzs__load "$f" || ((exit_code++))
# 	done

# 	return $exit_code
# }

# _myzs_load() {
# 	local folder="$1"
# 	! test -d "$folder" && throw "$folder Not EXIST!" && return 5
# 	_myzs_loop_load "$folder"
# }

# _myzs_raw_load() {
# 	local folder="$1"
# 	! test -d "$folder" && echo "CANNOT load $folder" && return 199
# 	_myzs_loop_load "$folder"
# }

# _myzs_raw_load "$MYZS_LIB"

# _myzs_print_log_seperate_tostd "setting"
# _myzs_raw_load "$MYZS_SETTING"

# _myzs_print_log_seperate_tostd "global"
# _myzs_load "$MYZS_GLOBAL"

# _myzs_print_log_seperate_tostd "custom"
# _myzs_load "$MYZS_CUSTOM"

# _myzs_print_log_seperate_tostd "main"
# _myzs_load "$MYZS_SRC"

# duration=$SECONDS
# min="$((duration / 60))"
# sec="$((duration % 60))"

# _myzs_print_log_seperate_tostd
# _myzs_print_log_tostd "status" "time" "$min minutes $sec seconds elapsed"
# _myzs_print_log_tofile "status" "time" "$min minutes $sec seconds elapsed"
