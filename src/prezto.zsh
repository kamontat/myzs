# shellcheck disable=SC1090,SC2148

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
	zsh "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
