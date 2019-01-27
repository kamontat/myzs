# shellcheck disable=SC1090,SC2148

gcloud_path='/usr/local/etc/google-cloud-sdk/path.zsh.inc'
if is_file_exist "$gcloud_path"; then
	source "$gcloud_path"
fi

gcloud_completion='/usr/local/etc/google-cloud-sdk/completion.zsh.inc'
if is_file_exist "$gcloud_completion"; then
	source "$gcloud_completion"
fi

if is_command_exist "kubectl"; then
	source <(kubectl completion zsh)
fi

if is_command_exist "colorls"; then
	source "$(dirname "$(gem which colorls)")/tab_complete.sh"
fi

# bash_completion="/usr/local/share/bash-completion/bash_completion"
# if is_file_exist "$bash_completion"; then
  # source "$bash_completion"
# fi

git_extras="/usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh"
if is_file_exist "$git_extras"; then
	source "$git_extras"
fi

asdf_file="/usr/local/etc/bash_completion.d/asdf.bash"
if is_file_exist "$asdf_file"; then
	source "$asdf_file"
fi

if is_file_exist "$GO_ZSH_COMPLETE" || is_folder_exist "$GO_ZSH_COMPLETE"; then
	fpath=("${fpath[@]}" "$GO_ZSH_COMPLETE")
fi

# Configure ZGEN Shell Completion Path
if is_string_exist "$ZGEN_HOME"; then
	fpath=("${fpath[@]}" "$ZGEN_HOME")
fi

wd_path="$ZGEN_HOME/mfaerevaag/wd-master"
if is_folder_exist "$wd_path"; then
	fpath=("${fpath[@]}" "$wd_path")
fi
