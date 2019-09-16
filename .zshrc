# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

#################################################
## Information                                 ##
## Maintain: Kamontat Chantrachirathumrong     ##
## Version:  3.4.0                             ##
## Since:    21/04/2018 (dd-mm-yyyy)           ##
## Updated:  16/08/2018 (dd-mm-yyyy)           ##
## License:  MIT                               ##
#################################################
## Changelogs                                  ##
## 3.4.0   - Merge person and default together ##
## 3.3.2   - Add new custom var and todo.txt   ##
#################################################
## Error: 2  wrong call function or method     ##
##        5  file/folder not exist             ##
##        10 variable not exist                ##
#################################################

export MYZS_TYPE="FULLY"

ROOT="${HOME}/.zshrc"
[ -h "$ROOT" ] && ROOT="$(readlink "$ROOT")"
ROOT="$(dirname "$ROOT")"

export MYZS_ROOT="$ROOT"
export MYZS_CON="${MYZS_ROOT}/const"
export MYZS_LIB="${MYZS_ROOT}/lib"

export MYZS_SRC="${MYZS_ROOT}/src"

export MYZS_ALIAS="${MYZS_SRC}/alias"     # for alias
export MYZS_ENV="${MYZS_SRC}/environment" # for environment variable
export MYZS_APP="${MYZS_SRC}/application" # for external application loader

export MYZS_PM="${MYZS_SRC}/pm" # for plugin management and package management

# progress libraries
source "${MYZS_SRC}/pre_script.sh"
source "${MYZS_SRC}/variable.sh"
source "${MYZS_LIB}/progress.sh"

pg_start
# Progress Mark namespace
#   1. Settings    - For setting and configuration
#   2. Libraries   - For libraries and helper method
#   3. Plugins     - For Package manager and Plugin manager
#   4. Environment - For environment variable
#   5. Alias       - For command alias settings
#   6. Application - For external application and CLI

pg_mark "Settings" "Loading default"
source "${MYZS_CON}/default.sh"
source "${MYZS_CON}/theme.sh" # load theme variable
source "${MYZS_CON}/location.sh"

pg_mark "Libraries" "Load helper method"
source "${MYZS_LIB}/helper.sh" || pg_mark_false "Loading helper library"
source "${MYZS_LIB}/lazyload.sh" || pg_mark_false "Loading lazyload library"
source "${MYZS_LIB}/setup.sh" || pg_mark_false "Loading setup file"

pg_mark "Plugins" "Setup zgen settings"
source "${MYZS_PM}/zgen-settings.sh" || pg_mark_false "Setting custom zgen settings"

pg_mark "Plugins" "Setup zgen plugins"
if is_string_exist "$ZGEN_HOME" && is_file_exist "${ZGEN_HOME}/zgen.zsh"; then
  source "${MYZS_PM}/plugins.sh"
  source "${MYZS_PM}/prezto-settings.sh"
  source "${ZGEN_HOME}/zgen.zsh"

  # reset zgen
  if [[ "$RESET_ZGEN" == true ]] &&
    is_command_exist "zgen"; then
    zgen reset
  fi

  if ! zgen saved || $ZGEN_FORCE_SAVE; then
    setup=()
    for setting in "${ZGEN_PREZTO_SETTING_LIST[@]}"; do
      if [[ "$setting" == "_END_" ]]; then
        zgen prezto "${setup[@]}"
        setup=()
      else
        setup+=("$setting")
      fi
    done

    zgen prezto

    for plugin in "${ZGEN_PREZTO_PLUGIN_LIST[@]}"; do
      zgen prezto "$plugin"
    done

    for plugin in "${ZGEN_PLUGIN_LIST[@]}"; do
      zgen load "$plugin"
    done

    # generate the init script from plugins above
    zgen save
  fi
  # https://github.com/hlissner/zsh-autopair#zgen--prezto-compatibility
  autopair-init
else
  pg_mark_false "Zgen not found"
fi

# Start recusive load environment defined
for i in ${MYZS_PM}/custom_plugins/*; do
  base="$(basename "$i")"
  pg_mark "Plugins" "$base"
  source_file "$base" "$i"
done

# Start recusive load environment defined
for i in ${MYZS_ENV}/*; do
  base="$(basename "$i")"
  pg_mark "Environment" "$base"
  source_file "$base" "$i"
done

# Start recusive load application defined settings
for i in ${MYZS_APP}/*; do
  base="$(basename "$i")"
  pg_mark "Application" "$base"
  source_file "$base" "$i"
done

# Start recusive load alias defined
for i in ${MYZS_ALIAS}/*; do
  base="$(basename "$i")"
  pg_mark "Alias" "$base"
  source_file "$base" "$i"
done

MYZS_ENV="$MYZS_ROOT/.env"
if is_file_exist "$MYZS_ENV"; then
  pg_mark "Settings" "Loading config from .env"
  source "$MYZS_ENV"
fi

pg_stop
