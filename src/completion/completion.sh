# shellcheck disable=SC1090,SC2148

# tabtab completion for yarn
source_file "$HOME/.config/yarn/global/node_modules/yarn-completions/node_modules/tabtab/.completions/yarn.zsh"

# google cloud path
source_file "/usr/local/etc/google-cloud-sdk/path.zsh.inc"

# google cloud completion
source_file "/usr/local/etc/google-cloud-sdk/completion.zsh.inc"

# git extra cli
source_file "/usr/local/opt/git-extras/share/git-extras/git-extras-completion.zsh"

# asdf version control
source_file "/usr/local/etc/bash_completion.d/asdf.bash"

if is_command_exist "kubectl"; then
  source <(kubectl completion zsh)
fi

if is_command_exist "colorls"; then
  source "$(dirname "$(gem which colorls)")/tab_complete.sh"
fi

if is_file_exist "$GO_ZSH_COMPLETE" || is_folder_exist "$GO_ZSH_COMPLETE"; then
  fpath=("${fpath[@]}" "$GO_ZSH_COMPLETE")
fi

# Configure ZGEN Shell Completion Path
if is_string_exist "$ZGEN_HOME"; then
  fpath=("${fpath[@]}" "$ZGEN_HOME")
fi

if is_folder_exist "$_PLUGINS_WD_HOME"; then
  fpath=($_PLUGINS_WD_HOME $fpath)
fi
