#!/usr/bin/env zsh
# shellcheck disable=SC1090

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

if [[ $MYZS_USE_ITERM == true ]] && _myzs_if_file_exist "${HOME}/.iterm2_shell_integration.zsh"; then
	_myzs__load "${HOME}/.iterm2_shell_integration.zsh"
else
	curl -L https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | zsh
	_myzs__load "${HOME}/.iterm2_shell_integration.zsh"
fi

# ZSH COMPLETE
fpath=($GO_ZSH_COMPLETE $fpath)

# The next line updates PATH for the Google Cloud SDK.
_myzs__load '/usr/local/etc/google-cloud-sdk/path.zsh.inc'

# The next line enables shell command completion for gcloud.
_myzs__load '/usr/local/etc/google-cloud-sdk/completion.zsh.inc'

# source <(kubectl completion zsh)
