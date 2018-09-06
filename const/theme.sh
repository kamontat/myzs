# shellcheck disable=SC1090,SC2148

# available theme
# https://mikebuss.com/2014/04/07/customizing-prezto/
# adam1         cloud         fire          oliver        pws           spaceship
# adam2         damoekri      giddie        paradox       redhat        steeef
# agnoster      default       kylewest      peepcode      restore       suse
# bart          elite         minimal       powerlevel9k  skwp          walters
# bigfade       elite2        nicoulaj      powerline     smiley        zefram
# clint         fade          off           pure          sorin
export CUSTOM_THEME=true
export THEME_NAME="sorin"

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
