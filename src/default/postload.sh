# shellcheck disable=SC1090,SC2148

if $AUTO_OPEN_PATH; then
	clipboard="$(pbpaste)"
	if is_folder_exist "$clipboard"; then
		cd "$clipboard" || echo "$clipboard not exist!"
	fi
fi
