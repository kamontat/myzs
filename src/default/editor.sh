# shellcheck disable=SC1090,SC2148

if is_command_exist "nvim"; then
	nvim_path="$(which nvim)"
	export GIT_EDITOR="$nvim_path"
	export VISUAL="$nvim_path"
	export EDITOR="$nvim_path"
fi

if is_command_exist "code-insiders"; then
	alias code='code-insiders'
fi

if is_command_exist "code" || is_command_exist "code-insiders"; then
	alias newcode='code --new-window'
	alias ncode='code --new-window'
	alias ccode='code --reuse-window'
fi

if is_command_exist "atom-beta"; then
	alias atom='atom-beta'
fi
