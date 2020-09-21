# shellcheck disable=SC1090,SC2148

export _MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS__SRC="${_MYZS_ROOT}/src"
export __MYZS__HLP="${_MYZS_ROOT}/src/utils/helper"
export __MYZS__PLG="${_MYZS_ROOT}/plugins"
export __MYZS__COM="${_MYZS_ROOT}/resources/completion"

export ZPLUG_HOME="${MYZS_ZPLUG:-${_MYZS_ROOT}/zplug}"

export __MYZS__USER="${MYZS_USER:-$USER}"
export __MYZS__OWNER="Kamontat Chantrachirathumrong"
export __MYZS__VERSION="5.1.0"
export __MYZS__SINCE="21 Apr 2018"
export __MYZS__LAST_UPDATED="16 Sep 2020"
export __MYZS__LICENSE="MIT"
export __MYZS__MODULES=()

# Accept values: FULLY | SMALL
#   1. FULLY -> full command with advance support on zsh script
#   2. SMALL -> small utils with alias for bash and server bash
export __MYZS__TYPE="${MYZS_TYPE:-FULLY}"

export __MYZS__REVOLVER_CMD="${__MYZS__SRC}/utils/revolver"

# ########################## #
# Start loading dependencies #
# ########################## #

source "${__MYZS__HLP}/index.sh"

_myzs:internal:module:initial

# load progress bar
if _myzs:internal:checker:fully-type; then
  _myzs:internal:module:load "builtin#utils/progress.sh"
else
  _myzs:internal:module:load "builtin#utils/dump-progress.sh"
fi

myzs:pg:start

# initial system config
myzs:pg:mark "Commandline" "Setup system settings"
_myzs:internal:module:load "settings/system.sh" || myzs:pg:mark-fail "Cannot load system variable"

# initial zsh config
if _myzs:internal:checker:fully-type; then
  myzs:pg:mark "Commandline" "Setup commandline settings"
  _myzs:internal:module:load "settings/zsh.sh" || myzs:pg:mark-fail "Cannot load zsh settings"
fi

# initial zplug config
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:mark "ZPlugin" "Initial zplug configuration"
  _myzs:internal:module:load "zplug#init.zsh" || myzs:pg:mark-fail "Cannot load zplug initial script"
fi

# load zplug plugins
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:mark "ZPlugin" "Initial zplug plugin list"
  _myzs:internal:module:load "settings/plugins.sh" || myzs:pg:mark-fail "Cannot load zplug plugins list"

  myzs:zplug:initial-plugins # initial plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -rq; then
      echo
      zplug install
    fi
  fi

  myzs:pg:mark "ZPlugin" "Loading zplug plugin list"
  # load new plugins to system
  zplug load --verbose >>"$MYZS_ZPLUG_LOGPATH"

  myzs:pg:mark "ZPlugin" "Setup zplug plugin config"
  myzs:zplug:setup-plugins
fi

# load myzs plugins
myzs:pg:mark "Plugin" "Initial myzs plugin list"
for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
  myzs:pg:mark "Plugin" "Loading ${plugin} plugin"
  if ! _myzs:internal:plugin:name-deserialize "$plugin" _myzs:internal:initial-plugin; then
    myzs:pg:mark-fail "Cannot load plugin"
  fi
done

# apply all module
myzs:pg:mark "Module" "Initial modules list"
_myzs:private:core:load-module() {
  local module_type="$1" module_name="$2" module_fullpath="$3"
  local module_key
  module_key="$(_myzs:internal:module:name-serialize "${module_type}" "${module_name}")"

  if [[ "${MYZS_LOADING_MODULES[*]}" =~ $module_key ]]; then
    myzs:pg:mark "${module_type}" "Loading ${module_name}"

    if _myzs:internal:checker:fully-type || [[ $module_name =~ "alias" ]]; then
      _myzs:internal:module:load "${module_key}" || myzs:pg:mark-fail "Cannot load $module_fullpath"
    else
      myzs:pg:mark-fail "cannot load ${module_key} when TYPE=$__MYZS__TYPE"
    fi
  else
    _myzs:internal:module:skip "${module_key}"
    _myzs:internal:log:warn "skipped module"
  fi

  _myzs:internal:completed
}
_myzs:internal:module:total-list _myzs:private:core:load-module

# load environment
myzs:pg:mark "Helper" "Loading environment variable"
env_list=()
export __MYZS__ENVFILE="$_MYZS_ROOT/.env"
_myzs:internal:module:initial "$__MYZS__ENVFILE"
while IFS= read -r line; do
  key="${line%=*}"
  value="${line##*=}"

  if _myzs:internal:checker:string-exist "$key" && _myzs:internal:checker:string-exist "$value"; then
    env_list+=("$key")
    # shellcheck disable=SC2163
    export "${key}"="${value}"
  fi
done <"$__MYZS__ENVFILE"
[[ ${#env_list[@]} -gt 0 ]] && _myzs:internal:log:info "exporting [ ${env_list[*]} ]"
unset line env_list

# load setup file
myzs:pg:mark "Helper" "Loading setup file"
$MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL && myzs-setup-local

myzs:pg:stop

_myzs:internal:module:initial "$0"
if _myzs:internal:checker:fully-type; then
  # auto open path from clipboard
  if [[ "$MYZS_SETTINGS_AUTO_OPEN_PATH" == "true" ]]; then
    __clipboard="$(pbpaste)"
    if _myzs:internal:checker:folder-exist "$__clipboard"; then
      cd "$__clipboard" || echo "$__clipboard not exist!"
    fi

    unset __clipboard
  fi

  # print open welcome message
  if _myzs:internal:checker:string-exist "$MYZS_SETTINGS_WELCOME_MESSAGE"; then
    echo
    echo "$MYZS_SETTINGS_WELCOME_MESSAGE"
  fi

  # exec start command
  if _myzs:internal:checker:command-exist "$MYZS_START_COMMAND"; then
    $MYZS_START_COMMAND "${MYZS_START_COMMAND_ARGUMENTS[@]}"
  fi
fi
