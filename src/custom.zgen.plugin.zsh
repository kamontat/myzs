# shellcheck disable=SC1090,SC2148

wd_name="${HOME}/.zgen/mfaerevaag/wd-master"
if is_command_exist "git" && ! is_folder_exist "$wd_name"; then
	mkdir "$wd_name" &>/dev/null
	git clone "https://github.com/mfaerevaag/wd.git" "$wd_name" &>/dev/null

	cp "${wd_name}/wd.1" "/usr/share/man/man1/wd.1"
fi

# contrib="${HOME}/.zgen/sorin-ionescu/prezto-master/contrib"
# if ! is_folder_exist "$contrib"; then
# 	git clone https://github.com/belak/prezto-contrib "$contrib"
# 	cd contrib || exit 1
# 	git submodule init
# 	git submodule update
# fi

spaceship_url="https://github.com/denysdovhan/spaceship-prompt.git"
spaceship_location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/spaceship"

if ! is_folder_exist "$spaceship_location"; then
	git clone "$spaceship_url" "$spaceship_location" &>/dev/null
	ln -s "${spaceship_location}/spaceship.zsh-theme" ~/.zprezto/modules/prompt/functions/prompt_spaceship_setup
fi

if is_file_exist "${spaceship_location}/spaceship.zsh-theme"; then
	prompt spaceship
fi
