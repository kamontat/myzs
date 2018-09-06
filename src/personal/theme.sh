# shellcheck disable=SC1090,SC2148

if [[ $CUSTOM_THEME == false ]]; then
	spaceship_url="https://github.com/denysdovhan/spaceship-prompt.git"
	spaceship_location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/spaceship"

	if ! is_folder_exist "$spaceship_location"; then
		git clone "$spaceship_url" "$spaceship_location" &>/dev/null
		ln -s "${spaceship_location}/spaceship.zsh-theme" ~/.zprezto/modules/prompt/functions/prompt_spaceship_setup
	fi

	if is_file_exist "${spaceship_location}/spaceship.zsh-theme"; then
		prompt spaceship
	fi
fi
