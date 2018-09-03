# shellcheck disable=SC1090,SC2148

# init promt theme

SPACESHIP_PROMPT_ORDER=(
	time
	user
	host
	hg
	package
	node
	ruby
	elixir
	xcode
	swift
	golang
	php
	rust
	julia
	docker
	aws
	venv
	conda
	pyenv
	dotnet
	ember
	line_sep
	dir
	git
	exec_time
	line_sep
	battery
	exit_code
	char
)

SPACESHIP_RPROMPT_ORDER=(
	jobs
)

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT="%D{%d-%m-%Y %H.%M.%S}"
SPACESHIP_BATTERY_SHOW=always

SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=1
