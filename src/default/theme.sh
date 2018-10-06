# shellcheck disable=SC1090,SC2148

url="$CUSTOM_THEME_URL"
test -z "$url" &&
	url="https://github.com/denysdovhan/spaceship-prompt.git"

name="$CUSTOM_THEME_NAME"
test -z "$name" &&
	name="spaceship"

location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/$name"

prezto_folder="$HOME/.zprezto/modules/prompt/functions"

if [[ $CUSTOM_THEME == true ]]; then
	# guess theme file name
	theme_name="${location}/${name}.zsh-theme"
	is_file_exist "$theme_name" || theme_name="${location}/${name}.zsh"

	if ! is_folder_exist "$location"; then
		git clone "$url" "$location" &>/dev/null

		# link the theme file
		if is_file_exist "$theme_name"; then
			ln -s "$theme_name" "${prezto_folder}/prompt_${name}_setup"

			# custom async file
			if is_file_exist "${location}/async.zsh"; then
				ln -s "${location}/async.zsh" "${prezto_folder}/async"
			fi
		fi
	fi

	if is_file_exist "$theme_name"; then
		autoload -U promptinit
		promptinit
		prompt $name
	fi
fi
