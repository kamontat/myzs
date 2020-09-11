# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

_myzs:internal:alias "restart-zsh" "exec zsh"
_myzs:internal:alias "restart-bash" "exec bash"
_myzs:internal:alias "restart-fish" "exec fish"

_myzs:internal:alias "restart-shell" "restart-$(_myzs:internal:shell)"

_myzs:internal:alias "reshell" "restart-shell"
