# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "nvim"; then
  __myzs_alias "v" "nvim"
  __myzs_alias_force "vi" "nvim"

  __myzs_alias "vs" "sudo nvim"
  __myzs_alias "vis" "sudo nvim"
  __myzs_alias "vims" "sudo nvim"

  __myzs_alias "sv" "sudo nvim"
  __myzs_alias "svi" "sudo nvim"
  __myzs_alias "svim" "sudo nvim"
else
  __myzs_alias "v" "vim"

  __myzs_alias "vs" "sudo vim"
  __myzs_alias "vis" "sudo vim"
  __myzs_alias "vims" "sudo vim"

  __myzs_alias "sv" "sudo vim"
  __myzs_alias "svi" "sudo vim"
  __myzs_alias "svim" "sudo vim"
fi
