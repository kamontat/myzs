# shellcheck disable=SC1090,SC2148

if $AUTO_OPEN_PATH; then
  clipboard="$(pbpaste)"
  if is_folder_exist "$clipboard"; then
    cd "$clipboard" || echo "$clipboard not exist!"
  fi
fi

if is_string_exist "$WELCOME_MESSAGE"; then
  echo
  echo "$WELCOME_MESSAGE"
fi
