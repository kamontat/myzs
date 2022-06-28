# shellcheck disable=SC2148

export _MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS__SRC="${_MYZS_ROOT}/src"
export __MYZS__PLG="${_MYZS_ROOT}/plugins"
export __MYZS__COM="${_MYZS_ROOT}/resources/completion"

export __MYZS__LIB="${__MYZS__SRC}/lib"
export __MYZS__UTL="${__MYZS__SRC}/utils"

export ZPLUG_HOME="${MYZS_ZPLUG:-${_MYZS_ROOT}/zplug}"

export __MYZS__OWNER="Kamontat Chantrachirathumrong"
export __MYZS__VERSION="5.7.9"
export __MYZS__SINCE="21 Apr 2018"
export __MYZS__LAST_UPDATED="28 Jun 2022"
export __MYZS__LICENSE="AGPL-3.0 License"

export __MYZS__MODULES=()

# ########################## #
# Start loading dependencies #
# ########################## #

# shellcheck disable=SC1091
source "${__MYZS__UTL}/index.sh"

# load progress bar
if _myzs:internal:checker:fully-type; then
  _myzs:internal:module:load "builtin#lib/progress.sh"
else
  _myzs:internal:module:load "builtin#lib/dump-progress.sh"
fi

myzs:pg:start

# initial system config
myzs:pg:step "Command" "Setup system settings"
_myzs:internal:module:load "builtin#settings/system.sh" || myzs:pg:mark-fail "Commandline" "Cannot load system variable"

# initial path config
myzs:pg:step "Command" "Setup path settings"
_myzs:internal:module:load "builtin#settings/path.sh" || myzs:pg:mark-fail "Commandline" "Cannot load path variable"

# initial zsh config
if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:step "Command" "Setup commandline settings"
  _myzs:internal:module:load "builtin#settings/zsh.sh" || myzs:pg:mark-fail "Commandline" "Cannot load zsh settings"
fi

# load myzs plugins
myzs:pg:step "Plugin" "Initial ${#MYZS_LOADING_PLUGINS[@]} plugins"
for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
  if _myzs:internal:setting:is-disabled "plugin/aggregation"; then
    myzs:pg:step "Plugin" "Loaded plugin $plugin"
    if ! _myzs:internal:plugin:initial "$plugin"; then
      myzs:pg:mark-fail "Plugin" "Cannot load $plugin plugin"
      continue
    fi
  else
    _myzs:internal:plugin:initial "$plugin"
  fi
done

# load myzs modules
myzs:pg:step "Module" "Initial ${#MYZS_LOADING_MODULES[@]} modules"
for module in "${MYZS_LOADING_MODULES[@]}"; do
  if _myzs:internal:setting:is-disabled "module/aggregation"; then
    myzs:pg:step "Module" "Loaded module $module"
    if ! _myzs:internal:module:load "$module"; then
      myzs:pg:mark-fail "Module" "Cannot load $module module"
      continue
    fi
  else
    _myzs:internal:module:load "$module"
  fi
done

if _myzs:internal:setting:is-enabled "group"; then
  myzs:pg:step "Group" "Initial group data"
  _myzs:internal:group:initial "${MYZS_LOADING_GROUPS[@]}" || myzs:pg:mark-fail "Group" "Cannot load $? group"
fi

# initial zplug config
if _myzs:internal:checker:fully-type &&
  _myzs:internal:checker:shell:zsh &&
  _myzs:internal:setting:is-enabled "zplug"; then
  myzs:pg:step "ZPlugin" "Initial zplug configuration"
  _myzs:internal:module:load "zplug#init.zsh" || myzs:pg:mark-fail "ZPlugin" "Cannot load zplug initial script"

  myzs:pg:step "ZPlugin" "Initial zplug plugin list"
  _myzs:internal:module:load "builtin#settings/zplugins.sh" || myzs:pg:mark-fail "ZPlugin" "Cannot load zplug plugins list"

  myzs:zplug:initial-plugins # initial plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -rq; then
      echo
      zplug install
    fi
  fi

  myzs:pg:step "ZPlugin" "Loaded zplug plugin list"
  # load new plugins to system
  if ! zplug load --verbose >>"$MYZS_ZPLUG_LOGPATH"; then
    myzs:pg:mark-fail "ZPlugin" "Cannot load zplug plugin"
  fi

  myzs:pg:step "ZPlugin" "Setup zplug plugin config"
  if ! myzs:zplug:setup-plugins; then
    myzs:pg:mark-fail "ZPlugin" "Cannot configure zplug plugin"
  fi
fi

myzs:pg:stop
