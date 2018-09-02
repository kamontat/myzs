# shellcheck disable=SC1090,SC2148

if is_command_exist "kubectl"; then
	source <(kubectl completion zsh)
fi

gcloud_path='/usr/local/etc/google-cloud-sdk/path.zsh.inc'
if is_file_exist "$gcloud_path"; then
	source "$gcloud_path"
fi

gcloud_completion='/usr/local/etc/google-cloud-sdk/completion.zsh.inc'
if is_file_exist "$gcloud_completion"; then
	source "$gcloud_completion"
fi

if is_file_exist "$GO_ZSH_COMPLETE" || is_folder_exist "$GO_ZSH_COMPLETE"; then
	fpath=("${fpath[@]}" "$GO_ZSH_COMPLETE")
fi
