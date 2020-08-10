# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if $MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL; then
  cd_function() {
    cd "$1" && myzs-setup-local
  }
  __myzs_alias_force "cd" "cd_function"
fi
