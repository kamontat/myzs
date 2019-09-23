# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "thefuck"; then
  eval "$(thefuck --alias)" # setup thefuck
fi
