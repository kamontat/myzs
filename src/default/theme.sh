# shellcheck disable=SC1090,SC2148

# prezto_folder="$HOME/.zprezto/modules/prompt/functions"

# location="${HOME}/.zgen/sorin-ionescu/prezto-master/modules/prompt/external/$name"
personal_theme="${MYZS_PERSONAL}/theme/index.sh"

# load prompt init module
autoload -U promptinit &&
  promptinit

if is_file_exist "$personal_theme" && $personal_theme; then
  is_string_exist "$__MYZS_THEME_NAME" &&
    prompt "$__MYZS_THEME_NAME"
else
  PURE_CMD_MAX_EXEC_TIME=1

  # change the path color
  zstyle ':prompt:pure:path' color 'red'

  prompt "$DEFAULT_THEME_NAME"
fi
