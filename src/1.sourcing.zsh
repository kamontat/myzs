#!/usr/bin/env bash
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

if [[ $MYZS_USE_ITERM == true ]] && if_file_exist "${HOME}/.iterm2_shell_integration.zsh"; then
	_load "${HOME}/.iterm2_shell_integration.zsh"
else
	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | zsh
	_load "${HOME}/.iterm2_shell_integration.zsh"
fi
