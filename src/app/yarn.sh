# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export YARN_BIN="$(yarn global bin)"
if __myzs_is_command_exist "yarn"; then
  __myzs_append_path "$YARN_BIN"
fi
