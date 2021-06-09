# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

cd_function() {
  cd "$1" && myzs-setup-local
}

_myzs:internal:alias-force "cd" "cd_function"
