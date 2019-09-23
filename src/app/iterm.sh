# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export __ITERM_INTEGRATION="${HOME}/.iterm2_shell_integration.zsh"

if ! __myzs_is_file_exist "$__ITERM_INTEGRATION"; then
  curl -sL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi

__myzs_load "iterm integration script" "$__ITERM_INTEGRATION_SH"
