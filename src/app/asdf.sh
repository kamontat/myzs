# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "asdf"; then
  ASDF_HOME="$(brew --prefix asdf)"
  export ASDF_HOME

  # Install via Homebrew
  __myzs_load "ASDF setup script" "$ASDF_HOME/asdf.sh"
  __myzs_load "ASDF completion script" "$ASDF_HOME/etc/bash_completion.d/asdf.bash"
else
  __myzs_failure
fi
