# shellcheck disable=SC1090,SC2148

export is_command_exist
is_command_exist() {
	command -v "$1" &>/dev/null
}

export is_file_exist
is_file_exist() {
	test -f "$1"
}

export is_folder_exist
is_folder_exist() {
	test -d "$1"
}

export is_string_exist
is_string_exist() {
	test -n "$1"
}

export get_work_root
get_work_root() {
	echo "${WORK_ROOT}/$1"
}

export to_work_root
to_work_root() {
	local path
	path="$(get_work_root "$1")"
	if ! is_folder_exist "$path"; then
		mkdir -p "$path"
	fi

	cd "$path" || {
		echo "$path" &&
			return 1
	}
}
