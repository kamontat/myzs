# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_folder_exist "$HOME/Library/Android/sdk"; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"                        # android home
  export PATH="${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools" # android path
fi
