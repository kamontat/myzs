# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "nvim"; then
  _myzs:internal:alias "v" "nvim"
  _myzs:internal:alias-force "vi" "nvim"

  _myzs:internal:alias "vs" "sudo nvim"
  _myzs:internal:alias "vis" "sudo nvim"
  _myzs:internal:alias "vims" "sudo nvim"

  _myzs:internal:alias "sv" "sudo nvim"
  _myzs:internal:alias "svi" "sudo nvim"
  _myzs:internal:alias "svim" "sudo nvim"
else
  _myzs:internal:alias "v" "vim"

  _myzs:internal:alias "vs" "sudo vim"
  _myzs:internal:alias "vis" "sudo vim"
  _myzs:internal:alias "vims" "sudo vim"

  _myzs:internal:alias "sv" "sudo vim"
  _myzs:internal:alias "svi" "sudo vim"
  _myzs:internal:alias "svim" "sudo vim"
fi
