# shellcheck disable=SC1090,SC2148

export __ITERM_INTEGRATION_SH="${HOME}/.iterm2_shell_integration.zsh"

if ! is_file_exist "$__ITERM_INTEGRATION_SH"; then
  curl -sL https://iterm2.com/shell_integration/install_shell_integration_and_utilities.sh | bash
fi

source_file "$__ITERM_INTEGRATION_SH"
