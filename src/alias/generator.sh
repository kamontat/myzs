# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "generator"; then
  __myzs_alias "template" "generator"
  __myzs_alias "template_update" "generator --reinstall"
fi
