# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "gdate"; then
  _myzs:internal:alias "date" "gdate"
fi
