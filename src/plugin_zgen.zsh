#!/usr/bin/env bash

if _myzs_if_file_exist "${ZGEN_HOME}/zgen.zsh"; then
	source "${ZGEN_HOME}/zgen.zsh"
	if ! zgen saved; then
		# specify plugins here
		zgen oh-my-zsh plugins/git

		# generate the init script from plugins above
		zgen save
	else
		_myzs_print_error_tofile "plugin" "status" "init scipt doesn't exist!"
		return 1
	fi
else
	_myzs_print_error_tofile "plugin" "status" "zgen doesn't exist!"
	return 1
fi
