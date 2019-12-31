# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export __MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS_SOURCE_CODE="${__MYZS_ROOT}/src"
export __MYZS_RESOURCES="${__MYZS_ROOT}/resources"
export __MYZS_ZPLUG="${ZPLUG_HOME:-${__MYZS_ROOT}/zplug}"

export __MYZS_USER="${MYZS_USER:-$USER}"
export __MYZS_OWNER="Kamontat Chantrachirathumrong"
export __MYZS_VERSION="4.1.0"
export __MYZS_SINCE="21 Apr 2018"
export __MYZS_LAST_UPDATED="31 Dec 2019"
export __MYZS_LICENSE="MIT"

export __MYZS_CHANGELOGS=(
  "[4.1.0](31 Dec 2019){add more alias, fix some log detail missing, update path to avoid duplication}"
  "[4.0.0](23 Sep 2019){first version released}"
)

# Accept values: FULLY | SMALL
#   1. FULLY -> full command with advance support on zsh script
#   2. SMALL -> small utils with alias for bash and server bash
export __MYZS_TYPE="${MYZS_TYPE:-FULLY}"

export REVOLVER_CMD="${__MYZS_SOURCE_CODE}/utils/revolver"

# ########################## #
# Start loading dependencies #
# ########################## #

source "${__MYZS_SOURCE_CODE}/utils/helper.sh"

if __myzs_is_fully; then
  source "${__MYZS_SOURCE_CODE}/utils/progress.sh"
else
  source "${__MYZS_SOURCE_CODE}/utils/dump-progress.sh"
fi

pg_start

if __myzs_is_fully; then
  __myzs_load "ZPLUG initial script" "${__MYZS_ZPLUG}/init.zsh" || pg_mark_false "Cannot load zgen initial script"
fi

__myzs_load "System variable" "${__MYZS_SOURCE_CODE}/settings/system.sh" || pg_mark_false "Cannot load system variable"

# sleep 2

pg_mark "Commandline" "setup commandline settings"

if __myzs_is_fully; then
  __myzs_load "ZSH settings" "${__MYZS_SOURCE_CODE}/settings/zsh.sh" || pg_mark_false "Cannot load zsh settings"
fi

if __myzs_is_fully; then
  pg_mark "Plugin" "Loading plugins from zplug"

  __myzs_load "Plugins list" "${__MYZS_SOURCE_CODE}/settings/plugins.sh" || pg_mark_false "Cannot load zplug plugins list"

  __myzs__create_plugins # create plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
      echo
      zplug install
    fi
  fi

  # load new plugins to system
  zplug load --verbose >>"$__MYZS_ZPLUG_LOGFILE"
fi

pg_mark "Application" "Loading application setup script"

if __myzs_is_fully; then
  for __path in ${__MYZS_SOURCE_CODE}/app/*.sh; do
    __filename="$(basename $__path)"
    pg_mark "Application" "Loading ${__filename}"

    __myzs_load "${__filename}" "$__path" || pg_mark_false "Cannot load $__filename"
  done
fi

pg_mark "Helper" "Loading alias setup script"

for __path in ${__MYZS_SOURCE_CODE}/alias/*.sh; do
  __filename="$(basename $__path)"
  pg_mark "Helper" "Loading ${__filename} alias"

  __myzs_load "${__filename}" "$__path" || pg_mark_false "Cannot load $__filename"

  unset __filename
done

pg_stop

if __myzs_is_fully; then
  __myzs_load "environment file" "$MYZS_ROOT/.env"

  if [[ "$MYZS_SETTINGS_AUTO_OPEN_PATH" == "true" ]]; then
    __clipboard="$(pbpaste)"
    if __myzs_is_folder_exist "$__clipboard"; then
      cd "$__clipboard" || echo "$__clipboard not exist!"

      unset __clipboard
    fi
  fi

  if __myzs_is_string_exist "$MYZS_SETTINGS_WELCOME_MESSAGE"; then
    echo
    echo "$MYZS_SETTINGS_WELCOME_MESSAGE"
  fi
fi
