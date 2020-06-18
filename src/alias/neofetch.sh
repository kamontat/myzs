# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "neofetch"; then
  if __myzs_is_file_exist "$NEOFETCH_CONFIG"; then
    __myzs_alias "sysinfo" "neofetch --config $NEOFETCH_CONFIG"
  else
    __myzs_alias "sysinfo" "neofetch"
  fi
fi
