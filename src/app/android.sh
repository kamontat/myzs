# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:folder-exist "$HOME/Library/Android/sdk"; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"                        # android home
  export PATH="${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools" # android path
fi
