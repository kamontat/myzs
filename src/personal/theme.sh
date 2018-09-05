# shellcheck disable=SC1090,SC2148

spaceship_url="https://github.com/denysdovhan/spaceship-prompt.git"
spaceship_location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/spaceship"

if ! is_folder_exist "$spaceship_location"; then
	git clone "$spaceship_url" "$spaceship_location" &>/dev/null
	ln -s "${spaceship_location}/spaceship.zsh-theme" ~/.zprezto/modules/prompt/functions/prompt_spaceship_setup
fi

if is_file_exist "${spaceship_location}/spaceship.zsh-theme"; then
	prompt spaceship
fi

SPACESHIP_PROMPT_ORDER=(
	time
	user
	host
	package
	node
	ruby
	xcode
	swift
	golang
	php
	docker
	aws
	conda
	line_sep
	dir
	exec_time
	line_sep
	battery
	exit_code
	char
)

SPACESHIP_RPROMPT_ORDER=(
	jobs
	git
)

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT="%D{%d-%m-%Y %H.%M.%S}"
SPACESHIP_BATTERY_SHOW=always

SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=1
