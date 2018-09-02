# shellcheck disable=SC1090,SC2148

iterm_file="${HOME}/.iterm2_shell_integration.zsh"
if is_file_exist "$iterm_file"; then
	source "$iterm_file"
fi

travis_file="$HOME/.travis/travis.sh"
if is_file_exist "$travis_file"; then
	source "$travis_file"
fi
