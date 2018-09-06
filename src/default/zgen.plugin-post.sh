# shellcheck disable=SC1090,SC2148

wd_name="${HOME}/.zgen/mfaerevaag/wd-master"
if is_command_exist "git" && ! is_folder_exist "$wd_name"; then
	mkdir "$wd_name" &>/dev/null
	git clone "https://github.com/mfaerevaag/wd.git" "$wd_name" &>/dev/null

	cp "${wd_name}/wd.1" "/usr/share/man/man1/wd.1"
fi
