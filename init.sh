# shellcheck disable=SC1090,SC2148

export _MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS__SRC="${_MYZS_ROOT}/src"
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

source "${__MYZS__SRC}/utils/helper.sh"

__myzs_initial

if __myzs_is_fully; then
  source "${__MYZS__SRC}/utils/progress.sh"
else
  source "${__MYZS__SRC}/utils/dump-progress.sh"
fi

pg_start

pg_mark "Commandline" "setup system settings"
__myzs_load_module "settings/system.sh" "${__MYZS__SRC}/settings/system.sh" || pg_mark_false "Cannot load system variable"

if __myzs_is_fully; then
  pg_mark "Commandline" "setup commandline settings"
  __myzs_load_module "settings/zsh.sh" "${__MYZS__SRC}/settings/zsh.sh" || pg_mark_false "Cannot load zsh settings"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "setup plugin manager"
  __myzs_load_module "zplug/init.zsh" "${ZPLUG_HOME}/init.zsh" || pg_mark_false "Cannot load zplug initial script"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "Creating plugins for zplug"
  __myzs_load_module "settings/plugins.sh" "${__MYZS__SRC}/settings/plugins.sh" || pg_mark_false "Cannot load zplug plugins list"

  __myzs__create_plugins # create plugins

  # Install plugins if there are plugins that have not been installed
  if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -rq; then
      echo
      zplug install
    fi
  fi

  pg_mark "Plugin" "Loading plugins to zplug"
  # load new plugins to system
  zplug load --verbose >>"$MYZS_ZPLUG_LOGPATH"

  pg_mark "Plugin" "Settings plugins configuration"
  __myzs__setup_plugins
fi

pg_mark "Helper" "Loading setup scripts"
for __path in "${MYZS_LOADING_MODULES[@]}"; do
  pg_mark "Scripts" "Loading $__path"

  fullpath="${__MYZS__SRC}/${__path}"

  # supported modules
  if __myzs__is_valid_module "$__path"; then
    if __myzs_is_fully || [[ $__path =~ "alias" ]]; then
      __myzs_load_module "${__path}" "$fullpath" || pg_mark_false "Cannot load $__path"
    else
      pg_mark_false "non-alias modules cannot autoload in TYPE=$__MYZS__TYPE"
    fi
  else
    pg_mark_false "'$__path' not found in __MYZS__FULLY_MODULES"
  fi
done
unset __path

pg_mark "Helper" "Normalize all modules status"
for __component in "${__MYZS__FULLY_MODULES[@]}"; do
  if ! [[ "${MYZS_LOADING_MODULES[*]}" =~ $__component ]]; then
    fullpath="${__MYZS__SRC}/${__component}"
    __myzs_skip_module "${__component}" "$fullpath"
  fi
done
unset __component

pg_mark "Helper" "Loading environment variable"
env_list=()
export __MYZS__ENVFILE="$MYZS_ROOT/.env"

__myzs_initial "$__MYZS__ENVFILE"
while IFS= read -r line; do
  key="${line%=*}"
  value="${line##*=}"

  if __myzs_is_string_exist "$key" && __myzs_is_string_exist "$value"; then
    env_list+=("$key")
    # shellcheck disable=SC2163
    export "${key}"="${value}"
  fi
done <"$__MYZS__ENVFILE"
[[ ${#env_list[@]} -gt 0 ]] && __myzs_info "exporting [ ${env_list[*]} ]"
unset line env_list

pg_mark "Helper" "Loading setup file"
$MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL && myzs-setup-local

pg_stop

__myzs_initial "$0"
if __myzs_is_fully; then
  # auto open path from clipboard
  if [[ "$MYZS_SETTINGS_AUTO_OPEN_PATH" == "true" ]]; then
    __clipboard="$(pbpaste)"
    if __myzs_is_folder_exist "$__clipboard"; then
      cd "$__clipboard" || echo "$__clipboard not exist!"
    fi

    unset __clipboard
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
