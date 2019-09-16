# shellcheck disable=SC1090,SC2148

if is_string_exist "$THEME_NAME"; then
  autoload -U promptinit
  promptinit
  prompt "$THEME_NAME"
else
  log_warn "Settings" "cannot find THEME_NAME variable"
fi
