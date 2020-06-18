# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "gdate"; then
  __myzs_alias "date" "gdate"
fi
