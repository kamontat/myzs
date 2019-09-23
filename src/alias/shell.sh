# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

__myzs_alias "restart-zsh" "exec zsh"
__myzs_alias "restart-bash" "exec bash"
__myzs_alias "restart-fish" "exec fish"

if grep -q "zsh" <<<"$SHELL"; then
  __myzs_alias "restart-shell" "restart-zsh"
elif grep -q "bash" <<<"$SHELL"; then
  __myzs_alias "restart-shell" "restart-bash"
elif grep -q "fish" <<<"$SHELL"; then
  __myzs_alias "restart-shell" "restart-fish"
fi
