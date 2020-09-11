# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export FLUTTER_HOME="/usr/local/opt/flutter"

if _myzs:internal:checker:folder-exist "$FLUTTER_HOME"; then
  _myzs:internal:path-push "${FLUTTER_HOME}/bin"
  export DART_SDK="${FLUTTER_HOME}/bin/cache/dart-sdk"

  flutter config --no-analytics >/dev/null

  export DART_PUB_BIN="$HOME/.pub-cache/bin"
  if _myzs:internal:checker:folder-exist "$DART_PUB_BIN"; then
    _myzs:internal:path-push "${DART_PUB_BIN}"
  fi
fi
