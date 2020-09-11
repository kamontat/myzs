# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if $MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL; then
  cd_function() {
    cd "$1" && myzs-setup-local
  }
  _myzs:internal:alias-force "cd" "cd_function"
fi
