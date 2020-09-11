# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export NODE_LTS_PATH="/usr/local/opt/node@12/bin"
_myzs:internal:path-append "$NODE_LTS_PATH"

if _myzs:internal:checker:command-exist "yarn"; then
  export CYARN_BIN="$(yarn global bin)"
  _myzs:internal:path-append "$CYARN_BIN"
fi
