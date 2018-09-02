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
fi

if is_command_exist "nvim"; then
	alias v='nvim'
	alias vi='nvim'
	alias vim='nvim'
	alias vis='sudo nvim'
	alias svim='sudo nvim'
fi

if is_command_exist "yarn"; then
	alias y='yarn'
	alias yi='yarn install'
	alias ys='yarn start'
	alias yb='yarn build'
	alias yd='yarn dev'
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
