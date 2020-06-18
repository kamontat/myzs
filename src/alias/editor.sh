# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "code-insiders"; then
  __myzs_alias "code" "code-insiders"
  __myzs_alias "ncode" "code-insiders --new-window"
  __myzs_alias "ccode" "code-insiders --reuse-window"
elif __myzs_is_command_exist "code"; then
  __myzs_alias "ncode" "code --new-window"
  __myzs_alias "ccode" "code --reuse-window"
fi

if __myzs_is_command_exist "atom-beta"; then
  __myzs_alias "atom" "atom-beta"
fi
