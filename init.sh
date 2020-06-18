# shellcheck disable=SC1090,SC2148

export __MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS_SOURCE_CODE="${__MYZS_ROOT}/src"
export __MYZS_RESOURCES="${__MYZS_ROOT}/resources"
export __MYZS_ZPLUG="${ZPLUG_HOME:-${__MYZS_ROOT}/zplug}"

export __MYZS_USER="${MYZS_USER:-$USER}"
export __MYZS_OWNER="Kamontat Chantrachirathumrong"
export __MYZS_VERSION="4.5.1"
export __MYZS_SINCE="21 Apr 2018"
export __MYZS_LAST_UPDATED="18 Jun 2020"
export __MYZS_LICENSE="MIT"
export __MYZS_MODULES=()

export __MYZS_CHANGELOGS=(
  "4.5.1" "18 Jun 2020"
  " - update some default variable
 - improve documents on zshrc file"
  "4.5.0" "18 Jun 2020"
  " - Introduce new command 'myzs-info' for print myzs information
 - Introduce new command 'myzs-list-changelogs' for print myzs changelogs
 - Add filename to log message
 - Change log files location to /tmp/myzs/logs
 - Rename logfile variable from \$MYZS_LOGFILE to \$MYZS_LOGPATH
 - Update new changelog format"
  "4.4.0" "01 Jun 2020"
  " - Add substring history search plugins 
 - Add more alias and application"
  "4.3.0" "24 Apr 2020"
  " - Add modules loaded 
 - Add new myzs command myzs-list-modules 
 - Add start command"
  "4.2.0" "15 Apr 2020"
  " - Add skipping process 
 - Add new customizable settings"
  "4.1.1" "04 Feb 2020"
  " - Add documentation
 - Change some default value"
  "4.1.0" "31 Dec 2019"
  " - Add more alias
 - Fix log detail missing
 - Fix duplicate \$PATH variable"
  "4.0.0" "23 Sep 2019"
  " - First v4.x.x released"
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

__myzs_initial

if __myzs_is_fully; then
  source "${__MYZS_SOURCE_CODE}/utils/progress.sh"
else
  source "${__MYZS_SOURCE_CODE}/utils/dump-progress.sh"
fi

pg_start

pg_mark "Commandline" "setup system settings"
__myzs_load_module "system.sh" "${__MYZS_SOURCE_CODE}/settings/system.sh" || pg_mark_false "Cannot load system variable"

if __myzs_is_fully; then
  pg_mark "Commandline" "setup commandline settings"
  __myzs_load_module "zsh.sh" "${__MYZS_SOURCE_CODE}/settings/zsh.sh" || pg_mark_false "Cannot load zsh settings"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "setup plugin manager"
  __myzs_load_module "zplug/init.zsh" "${__MYZS_ZPLUG}/init.zsh" || pg_mark_false "Cannot load zplug initial script"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "Loading plugins from zplug"
  __myzs_load_module "plugins.sh" "${__MYZS_SOURCE_CODE}/settings/plugins.sh" || pg_mark_false "Cannot load zplug plugins list"

  __myzs__create_plugins # create plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -rq; then
      echo
      zplug install
    fi
  fi

  # load new plugins to system
  zplug load --verbose >>"$MYZS_ZPLUG_LOGPATH"
fi

pg_mark "Helper" "Loading application setup script"
if __myzs_is_fully; then
  for __path in "${__MYZS_SOURCE_CODE}"/app/*.sh; do
    __filename="$(basename "$__path")"
    pg_mark "Application" "Loading ${__filename}"

    if [[ "$MYZS_EXCLUDE_COMPONENTS" =~ ${__filename} ]]; then
      pg_mark_skip "${__filename}"
      __myzs_skip_module "${__filename}" "$__path"
    else
      __myzs_load_module "${__filename}" "$__path" || pg_mark_false "Cannot load $__filename"
    fi
  done
fi

pg_mark "Helper" "Loading alias setup script"
for __path in "${__MYZS_SOURCE_CODE}"/alias/*.sh; do
  __filename="$(basename "$__path")"
  pg_mark "Alias" "Loading ${__filename}"

  if [[ "$MYZS_EXCLUDE_COMPONENTS" =~ ${__filename} ]]; then
    pg_mark_skip "${__filename}"
    __myzs_skip_module "${__filename}" "$__path"
  else
    __myzs_load_module "${__filename}" "$__path" || pg_mark_false "Cannot load $__filename"
  fi

  unset __filename
done

pg_stop

__myzs_load "environment file" "$MYZS_ROOT/.env"

if __myzs_is_fully; then
  # auto open path from clipboard
  if [[ "$MYZS_SETTINGS_AUTO_OPEN_PATH" == "true" ]]; then
    __clipboard="$(pbpaste)"
    if __myzs_is_folder_exist "$__clipboard"; then
      cd "$__clipboard" || echo "$__clipboard not exist!"

      unset __clipboard
    fi
  fi

  # print open welcome message
  if __myzs_is_string_exist "$MYZS_SETTINGS_WELCOME_MESSAGE"; then
    echo
    echo "$MYZS_SETTINGS_WELCOME_MESSAGE"
  fi

  # exec start command
  if __myzs_is_command_exist "$MYZS_START_COMMAND"; then
    $MYZS_START_COMMAND "${MYZS_START_COMMAND_ARGUMENTS[@]}"
  fi
fi

__myzs_cleanup
