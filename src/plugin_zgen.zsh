if if_file_exist "${ZGEN_HOME}/zgen.zsh"; then
	source "${ZGEN_HOME}/zgen.zsh"
	if ! zgen saved; then
		# specify plugins here
		zgen oh-my-zsh plugins/git

		# generate the init script from plugins above
		zgen save
	else
		if_debug_print "plugin" "init scipt doesn't exist!"
		return 1
	fi
else
	if_debug_print "plugin" "zgen not exist!"
	return 1
fi
