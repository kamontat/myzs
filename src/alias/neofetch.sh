# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "neofetch"; then
  if _myzs:internal:checker:file-exist "$NEOFETCH_CONFIG"; then
    _myzs:internal:alias "sysinfo" "neofetch --config $NEOFETCH_CONFIG"
  else
    _myzs:internal:alias "sysinfo" "neofetch"
  fi
fi
