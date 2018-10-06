# shellcheck disable=SC1090,SC2148

prezto_folder="$HOME/.zprezto/modules/prompt/functions"

url="$CUSTOM_THEME_URL"
name="$CUSTOM_THEME_NAME"

location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/$name"

if [[ $CUSTOM_THEME == true ]] && test -n "$url" && test -n "$name"; then
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
		prompt "$name"
	fi
fi
