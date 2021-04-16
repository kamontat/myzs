# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:setting:is-enabled "setup-file/automatic"; then
  cd_function() {
    cd "$1" && myzs-setup-local
  }

  _myzs:internal:alias-force "cd" "cd_function"
fi
