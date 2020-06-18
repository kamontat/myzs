# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "fuck"; then
  __myzs_alias "f" "fuck"
  __myzs_alias "fy" "fuck --yes"
fi
