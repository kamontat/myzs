# code from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/correction.zsh
if [[ "$MYZS_USE_CORRECTION" == "true" ]]; then
	alias ebuild='nocorrect ebuild'
	alias gist='nocorrect gist'
	alias heroku='nocorrect heroku'
	alias hpodder='nocorrect hpodder'
	alias man='nocorrect man'
	alias mkdir='nocorrect mkdir'
	alias mv='nocorrect mv'
	alias mysql='nocorrect mysql'
	alias sudo='nocorrect sudo'

	setopt correct_all
fi
