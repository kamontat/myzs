# shellcheck disable=SC1090,SC2148

export rcd
rcd() {
	if is_string_exist "$WORK_ROOT"; then
		to_work_root "$1"
	fi
}

wcd() {
	if is_string_exist "$WORKSPACE_NAME"; then
		rcd "$WORKSPACE_NAME"
	fi
}

pcd() {
	if is_string_exist "$PROJECT_NAME"; then
		rcd "$PROJECT_NAME"
	fi
}

lcd() {
	if is_string_exist "$LAB_NAME"; then
		rcd "$LAB_NAME"
	fi
}

ncd() {
	if is_string_exist "$NOTE_NAME"; then
		rcd "$NOTE_NAME"
	fi
}
