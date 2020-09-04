# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

export NODE_LTS_PATH="/usr/local/opt/node@12/bin"
__myzs_append_path "$NODE_LTS_PATH"

if __myzs_is_command_exist "yarn"; then
  export CYARN_BIN="$(yarn global bin)"
  __myzs_append_path "$CYARN_BIN"
fi
