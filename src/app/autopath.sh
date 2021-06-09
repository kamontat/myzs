# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

if _myzs:internal:checker:fully-type; then
  __clipboard="$(pbpaste)"
  if _myzs:internal:checker:folder-exist "$__clipboard"; then
    cd "$__clipboard" || echo "$__clipboard not exist!"
  fi

  unset __clipboard
fi
