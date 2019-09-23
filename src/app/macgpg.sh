# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export MACGPG_BIN="/usr/local/MacGPG2/bin"
__myzs_append_path "$MACGPG_BIN"
