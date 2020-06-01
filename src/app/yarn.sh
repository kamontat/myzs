# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export NODE_LTS_PATH="/usr/local/opt/node@12/bin"
if __myzs_is_folder_exist "$NODE_LTS_PATH"; then
  __myzs_append_path "$NODE_LTS_PATH"
fi

if __myzs_is_command_exist "yarn"; then
  export CYARN_BIN="$(yarn global bin)"
  __myzs_append_path "$CYARN_BIN"
fi
