# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "generator"; then
  __myzs_alias "template" "generator"
  __myzs_alias "template_update" "generator --reinstall"
fi
