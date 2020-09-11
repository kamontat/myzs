# shellcheck disable=SC1090,SC2148

export _MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS__SRC="${_MYZS_ROOT}/src"
export __MYZS__HLP="${_MYZS_ROOT}/src/utils/helper"
export __MYZS__PGL="${_MYZS_ROOT}/plugins"
export __MYZS__RES="${_MYZS_ROOT}/resources"

export ZPLUG_HOME="${MYZS_ZPLUG:-${_MYZS_ROOT}/zplug}"

export __MYZS__USER="${MYZS_USER:-$USER}"
export __MYZS__OWNER="Kamontat Chantrachirathumrong"
export __MYZS__VERSION="4.8.0"
export __MYZS__SINCE="21 Apr 2018"
export __MYZS__LAST_UPDATED="10 Sep 2020"
export __MYZS__LICENSE="MIT"
export __MYZS__MODULES=()
export __MYZS__FULLY_MODULES=(
  "app/android.sh"
  "app/docker.sh"
  "app/fzf.sh"
  "app/kube.sh"
  "app/myzs.sh"
  "app/myzs-git.sh"
  "app/tmux.sh"
  "app/wireshark.sh"
  "app/asdf.sh"
  "app/flutter.sh"
  "app/gcloud.sh"
  "app/go.sh"
  "app/iterm.sh"
  "app/macgpg.sh"
  "app/thefuck.sh"
  "app/travis.sh"
  "app/yarn.sh"
  "alias/initial.sh"
  "alias/myzs.sh"
  "alias/agoda.sh"
  "alias/docker.sh"
  "alias/fuck.sh"
  "alias/git.sh"
  "alias/mac.sh"
  "alias/shell.sh"
  "alias/vim.sh"
  "alias/coreutils.sh"
  "alias/editor.sh"
  "alias/generator.sh"
  "alias/github.sh"
  "alias/neofetch.sh"
  "alias/short.sh"
  "alias/yarn.sh"
  "alias/project.sh"
)

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

if _myzs:internal:checker:fully-type; then
  source "${__MYZS__SRC}/utils/progress.sh"
else
  source "${__MYZS__SRC}/utils/dump-progress.sh"
fi

myzs:pg:start

myzs:pg:mark "Commandline" "Setup system settings"
_myzs:internal:module:load "settings/system.sh" "${__MYZS__SRC}/settings/system.sh" || myzs:pg:mark-fail "Cannot load system variable"

if _myzs:internal:checker:fully-type; then
  myzs:pg:mark "Commandline" "Setup commandline settings"
  _myzs:internal:module:load "settings/zsh.sh" "${__MYZS__SRC}/settings/zsh.sh" || myzs:pg:mark-fail "Cannot load zsh settings"
fi

if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:mark "ZPlugin" "Initial zplug configuration"
  _myzs:internal:module:load "zplug/init.zsh" "${ZPLUG_HOME}/init.zsh" || myzs:pg:mark-fail "Cannot load zplug initial script"
fi

if _myzs:internal:checker:fully-type && _myzs:internal:checker:shell:zsh; then
  myzs:pg:mark "ZPlugin" "Initial zplug plugin list"
  _myzs:internal:module:load "settings/plugins.sh" "${__MYZS__SRC}/settings/plugins.sh" || myzs:pg:mark-fail "Cannot load zplug plugins list"

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

myzs:pg:mark "Helper" "Loading setup scripts"
for __path in "${MYZS_LOADING_MODULES[@]}"; do
  myzs:pg:mark "Scripts" "Loading $__path"

  fullpath="${__MYZS__SRC}/${__path}"

  # supported modules
  if _myzs:internal:module:checker:validate "$__path"; then
    if _myzs:internal:checker:fully-type || [[ $__path =~ "alias" ]]; then
      _myzs:internal:module:load "${__path}" "$fullpath" || myzs:pg:mark-fail "Cannot load $__path"
    else
      myzs:pg:mark-fail "non-alias modules cannot autoload in TYPE=$__MYZS__TYPE"
    fi
  else
    myzs:pg:mark-fail "'$__path' not found in __MYZS__FULLY_MODULES"
  fi
done
unset __path

myzs:pg:mark "Helper" "Normalize all modules status"
for __component in "${__MYZS__FULLY_MODULES[@]}"; do
  if ! [[ "${MYZS_LOADING_MODULES[*]}" =~ $__component ]]; then
    fullpath="${__MYZS__SRC}/${__component}"
    _myzs:internal:module:skip "${__component}" "$fullpath"
  fi
done
unset __component

myzs:pg:mark "Plugin" "Initial myzs plugin list"
_myzs:internal:initial-plugins

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
