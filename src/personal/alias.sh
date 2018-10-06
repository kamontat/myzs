# shellcheck disable=SC1090,SC2148

alias color-test='bash <(curl -sL https://raw.githubusercontent.com/kamontat/bash-color/master/color_test.sh)'
alias split='bash <(curl -sL https://gist.githubusercontent.com/kamontat/97ea3378c5d323b9b430aeda8b5f80df/raw/dbda55f2cadc0481b3a27f4ffc13602c6b7ffe8f/sep.sh)'

if is_command_exist "gitmoji"; then
	alias gj='gitmoji'
	alias gji='git init; gj -i'
	alias gj_remove='gj --remove'
	alias gjc='gj --commit'
	alias gj_list='gj --list'
	alias gj_update='gj --update'
fi

if is_command_exist "gitgo"; then
	alias gg='gitgo'
	alias ggo='gitgo'
  alias ggc='gitgo commit'
  alias ggb='gitgo branch'
  alias ggi='gitgo init --local'
  alias ggI='gitgo init --global'
fi

if is_file_exist "$HOME/.github/dotgithub"; then
	alias dotgithub='~/.github/dotgithub'
fi

if is_command_exist "gnomon"; then
	alias atime='gnomon'
	alias stime='gnomon'
fi

if is_command_exist "generator"; then
	alias template='generator'
	alias template_update='generator --reinstall'
fi

if is_command_exist "cat-syntax"; then
	alias cat='cat-syntax'
fi

# https://github.com/athityakumar/colorls
if is_command_exist "colorls"; then
	alias lc='colorls --sd'
	alias lca='lc -lA'
	alias lcs='lc --gs'
	alias lcas='lc -lA --gs'
	alias lcsa='lc --gs --gs'
	alias lct='lc --tree'
	alias lcr='lc --report'
fi

if is_command_exist "system_profiler"; then
	alias batt='system_profiler SPPowerDataType'
fi

if is_command_exist "neofetch"; then
	if is_file_exist "$HOME/.config/neofetch/short-config"; then
		alias sysinfo='neofetch --config $HOME/.config/neofetch/short-config'
	else
		alias sysinfo='neofetch'
	fi
fi
