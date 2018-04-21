#!/usr/bin/env bash
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

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
	jobs
	char
)

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT="%D{%d-%m-%Y %H.%M.%S}"
SPACESHIP_BATTERY_SHOW=always
SPACESHIP_EXIT_CODE_SHOW=true
