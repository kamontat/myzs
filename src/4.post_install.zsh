#!/usr/bin/env zsh
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  2.0.0
# since:    21/04/2018

# set -x

_myzs_clear_env() {
	local env_values
	env_values="$(_myzs_list_myzs_env)"
	while read -r line; do
		name="${line%%=*}"
		if ! _myzs_is_necessary_env "$name"; then
			unset "$name" &&
				_myzs_print_silly_tofile "clear" "unset" "$name"
		else
			_myzs_print_warning_tofile "clear" "ignore" "$name"
		fi
	done <<<"$env_values"
}

_myzs_is_necessary_env() {
	local exclude=("MYZS_ROOT" "MYZS_GLOBAL" "MYZS_SETTING" "MYZS_LIB")
	exclude+=(
		"MYZS_WORK_ROOT"
		"MYZS_WORKSPACE_DIRNAME" "MYZS_PROJECT_DIRNAME"
		"MYZS_LAB_DIRNAME" "MYZS_LIBRARY_DIRNAME"
		"MYZS_LOG_STORAGE" "MYZS_LOG_HEAD_FILE"
		"MYZS_LOG_EXTENSION" "MYZS_ERROR_EXTENSION"
		"MYZS_DATE_FORMAT"
	)
	exclude+=("MYZS_ERROR_FILE" "MYZS_LOG_FILE")
	exclude+=("MYZS_DEBUG_MODE")

	for i in "${exclude[@]}"; do
		[[ "$1" == "$i" ]] && return 0
	done

	return 1
}

_myzs_clear_env

_myzs_print_log_seperate_tofile "END"

_myzs_print_error_seperate_tofile "END"
