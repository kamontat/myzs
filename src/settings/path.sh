# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

__myzs_push_path "/usr/local/opt/openssl"

__myzs_push_path "/usr/local/opt/coreutils/libexec/gnubin"

__myzs_push_path "/Users/kamontat/.rbenv/shims"

__myzs_push_path "/usr/local/opt/coreutils/libexec/gnubin"

__myzs_push_path "/usr/local/opt/icu4c/bin"

__myzs_push_path "/usr/local/opt/icu4c/sbin"

__myzs_manpath "/usr/local/opt/coreutils/libexec/gnuman"

__myzs_manpath "/usr/local/bin/_NDD_FOLDER/man"
