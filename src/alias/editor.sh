# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "code-insiders"; then
  _myzs:internal:alias "code" "code-insiders"
  _myzs:internal:alias "ncode" "code-insiders --new-window"
  _myzs:internal:alias "ccode" "code-insiders --reuse-window"
elif _myzs:internal:checker:command-exist "code"; then
  _myzs:internal:alias "ncode" "code --new-window"
  _myzs:internal:alias "ccode" "code --reuse-window"
fi

if _myzs:internal:checker:command-exist "atom-beta"; then
  _myzs:internal:alias "atom" "atom-beta"
fi
