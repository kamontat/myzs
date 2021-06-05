# shellcheck disable=SC2148

export _MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS__SRC="${_MYZS_ROOT}/src"
export __MYZS__HLP="${_MYZS_ROOT}/src/utils/helper"
export __MYZS__PLG="${_MYZS_ROOT}/plugins"
export __MYZS__COM="${_MYZS_ROOT}/resources/completion"

export ZPLUG_HOME="${MYZS_ZPLUG:-${_MYZS_ROOT}/zplug}"

export __MYZS__OWNER="Kamontat Chantrachirathumrong"
export __MYZS__VERSION="5.5.0"
export __MYZS__SINCE="21 Apr 2018"
export __MYZS__LAST_UPDATED="05 Jun 2021"
export __MYZS__LICENSE="AGPL-3.0 License"

export __MYZS__MODULES=()
export __MYZS__PLUGINS=()
export __MYZS__GROUPS=()

# ########################## #
# Start loading dependencies #
# ########################## #

# shellcheck disable=SC1091
source "${__MYZS__HLP}/index.sh"

_myzs:internal:setting:initial
_myzs:internal:module:initial "$0"

# load progress bar
if _myzs:internal:checker:fully-type; then
  _myzs:internal:module:load "builtin#utils/progress.sh"
else
  _myzs:internal:module:load "builtin#utils/dump-progress.sh"
fi

myzs:pg:start

# initial system config
myzs:pg:mark "Commandline" "Setup system settings"
_myzs:internal:module:load "builtin#settings/system.sh" || myzs:pg:mark-fail "Cannot load system variable"

# initial path config
myzs:pg:mark "Commandline" "Setup path settings"
_myzs:internal:module:load "builtin#settings/path.sh" || myzs:pg:mark-fail "Cannot load path variable"

# initial zsh config
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:mark "Commandline" "Setup commandline settings"
  _myzs:internal:module:load "builtin#settings/zsh.sh" || myzs:pg:mark-fail "Cannot load zsh settings"
fi

# initial zplug config
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh && _myzs:internal:setting:is-enabled "myzs/zplug"; then
  myzs:pg:mark "ZPlugin" "Initial zplug configuration"
  _myzs:internal:module:load "zplug#init.zsh" || myzs:pg:mark-fail "Cannot load zplug initial script"
fi

# load zplug plugins
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh && _myzs:internal:setting:is-enabled "myzs/zplug"; then
  myzs:pg:mark "ZPlugin" "Initial zplug plugin list"
  _myzs:internal:module:load "builtin#settings/plugins.sh" || myzs:pg:mark-fail "Cannot load zplug plugins list"

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
  if ! zplug load --verbose >>"$MYZS_ZPLUG_LOGPATH"; then
    myzs:pg:mark-fail "Cannot load zplug plugin"
  fi

  myzs:pg:mark "ZPlugin" "Setup zplug plugin config"
  if ! myzs:zplug:setup-plugins; then
    myzs:pg:mark-fail "Cannot configure zplug plugin"
  fi
fi

# load myzs plugins
myzs:pg:mark "Plugin" "Initial myzs plugin list"
for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
  myzs:pg:mark "Plugin" "Downloading ${plugin} plugin"
  if ! _myzs:internal:plugin:name-deserialize "$plugin" _myzs:internal:plugin:load; then
    myzs:pg:mark-fail "Cannot load myzs plugin"
  fi
done

# apply all module
myzs:pg:mark "Module" "Initial modules list"
_myzs:private:core:load-module() {
  local module_type="$1" module_name="$2" module_fullpath="$3"
  local module_key
  module_key="$(_myzs:internal:module:name-serialize "${module_type}" "${module_name}")"

  # TODO: improve throw error if loading module is not exist in existing module
  if [[ "${MYZS_LOADING_MODULES[*]}" =~ $module_key ]]; then
    myzs:pg:mark "Module" "Loading ${module_name} (${module_type})"

    # if myzs is small type, not load anything except alias
    if _myzs:internal:checker:small-type && ! [[ $module_name =~ "alias" ]]; then
      myzs:pg:mark-fail "cannot load ${module_key} when TYPE is small"
    else
      _myzs:internal:module:load "${module_key}" || myzs:pg:mark-fail "Cannot load $module_fullpath"
    fi
  else
    _myzs:internal:module:skip "${module_key}"
    _myzs:internal:log:warn "skipped module"
  fi

  _myzs:internal:module:cleanup
  _myzs:internal:completed
}
_myzs:internal:module:total-list _myzs:private:core:load-module

# load setup file
if _myzs:internal:setting:is-enabled "setup-file/automatic"; then
  myzs:pg:mark "Helper" "Loading setup file"
  myzs-setup-local
fi

# loading path if auto open is enabled
if _myzs:internal:checker:fully-type; then
  if _myzs:internal:setting:is-enabled "automatic/open-path"; then
    myzs:pg:mark "Helper" "Loading setup file"
    __clipboard="$(pbpaste)"
    if _myzs:internal:checker:folder-exist "$__clipboard"; then
      cd "$__clipboard" || echo "$__clipboard not exist!"
    fi

    unset __clipboard
  fi
fi

myzs:pg:stop
