# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

export __ITERM_INTEGRATION="${HOME}/.iterm2_shell_integration.zsh"

if ! _myzs:internal:checker:file-exist "$__ITERM_INTEGRATION"; then
  curl -sL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi

_myzs:internal:load "iterm integration script" "$__ITERM_INTEGRATION"
