# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "neofetch"; then
  if __myzs_is_file_exist "$NEOFETCH_CONFIG"; then
    __myzs_alias "sysinfo" "neofetch --config $NEOFETCH_CONFIG"
  else
    __myzs_alias "sysinfo" "neofetch"
  fi
fi
