# shellcheck disable=SC1090,SC2148

export FLUTTER_HOME="/usr/local/opt/flutter"

if is_folder_exist "$FLUTTER_HOME"; then
  export PATH="$PATH:${FLUTTER_HOME}/bin"
  export DART_SDK="${FLUTTER_HOME}/bin/cache/dart-sdk"

  flutter config --no-analytics >/dev/null
fi
