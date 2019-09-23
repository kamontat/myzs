# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "fuck"; then
  __myzs_alias "f" "fuck"
  __myzs_alias "fy" "fuck --yes"
fi
