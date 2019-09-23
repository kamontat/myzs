# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export FLUTTER_HOME="/usr/local/opt/flutter"

if __myzs_is_folder_exist "$FLUTTER_HOME"; then
  __myzs_push_path "${FLUTTER_HOME}/bin"
  export DART_SDK="${FLUTTER_HOME}/bin/cache/dart-sdk"

  flutter config --no-analytics >/dev/null

  export DART_PUB_BIN="$HOME/.pub-cache/bin"
  if __myzs_is_folder_exist "$DART_PUB_BIN"; then
    __myzs_push_path "${DART_PUB_BIN}"
  fi
fi
