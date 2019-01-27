# shellcheck disable=SC1090,SC2148

# main script
myzs() {
	local param="$1"
	if [[ "$param" == "upload" ]]; then
		myzs-upload
	elif [[ "$param" == "download" ]]; then
		myzs-download
	elif [[ "$param" == "speed" ]]; then
		myzs-speed
	elif [[ "$param" == "theme" ]]; then
		myzs-theme "$2"
	else
		echo "Help: This is myzs public APIs
parameter: ['help', 'upload', 'download', 'speed', 'theme']
1. upload [<version>]  -> upload current changes to github
2. download            -> download the change from github
3. speed               -> change prompt theme to none
4. theme <name>        -> change theme to input name
"
	fi
}

myzs-upload() {
	test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

	cd "$MYZS_ROOT" || exit 1
	echo "Start upload current change to github"
	git status --short
	./deploy.sh
}

myzs-download() {
	test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

	cd "$MYZS_ROOT" || exit 1
	echo "Start download the change from github"
	git fetch
	git pull
}

myzs-speed() {
	is_command_exist prompt &&
		prompt restore
}

myzs-teardown() {
	is_command_exist prompt_powerlevel9k_teardown &&
		prompt_powerlevel9k_teardown
}

myzs-theme() {
	myzs-teardown
	is_command_exist prompt &&
		prompt "$1"
}

myzs-theme-powerlevel() {
	myzs-theme "powerlevel9k"
}

myzs-theme-pure() {
	myzs-theme "pure"
}

myzs-theme-spaceship() {
	myzs-theme "spaceship"
}

myzs-theme-steeef() {
	myzs-theme "steeef"
}

myzs-close-all() {
	local opened_apps
	opened_apps=$(osascript -e 'tell application "System Events" to get name of (processes where background only is false)')

	apps=("$(echo "${opened_apps//, /\n}")")

	for app in "${apps[@]}"; do
		iapp="$(echo "$app" | tr '[:upper:]' '[:lower:]')"
		if [[ "$iapp" != "iterm" ]] && [[ "$iapp" != "iterm2" ]] && [[ "$iapp" != "finder" ]]; then
			osascript -e "quit app \"$app\""
		fi
	done
}
