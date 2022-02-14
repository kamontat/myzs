# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

etc_paths="/etc/paths.d"
if test -d "$etc_paths"; then
  for path_name in "$etc_paths"/*; do
    while read -r p; do
      _myzs:internal:path-push "$p"
    done <"$path_name"
  done
fi

_myzs:internal:path-push "/usr/local/opt/openssl"

_myzs:internal:path-push "/usr/local/opt/coreutils/libexec/gnubin"

_myzs:internal:path-push "$HOME/.rbenv/shims"

_myzs:internal:path-push "/usr/local/opt/coreutils/libexec/gnubin"

_myzs:internal:path-push "/usr/local/opt/icu4c/bin"

_myzs:internal:path-push "/usr/local/opt/icu4c/sbin"

_myzs:internal:manpath-push "/usr/local/opt/coreutils/libexec/gnuman"
