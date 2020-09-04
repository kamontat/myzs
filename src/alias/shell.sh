# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

__myzs_alias "restart-zsh" "exec zsh"
__myzs_alias "restart-bash" "exec bash"
__myzs_alias "restart-fish" "exec fish"

__myzs_alias "restart-shell" "restart-$(__myzs_on_shell)"

__myzs_alias "reshell" "restart-shell"
