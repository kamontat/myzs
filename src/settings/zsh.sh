# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

unsetopt correct_all
unsetopt correct

zstyle :prezto:load pmodule
