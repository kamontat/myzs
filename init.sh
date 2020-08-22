# shellcheck disable=SC1090,SC2148

export __MYZS_ROOT="${MYZS_ROOT:-"$HOME/.myzs"}"
export __MYZS_SOURCE_CODE="${__MYZS_ROOT}/src"
export __MYZS_RESOURCES="${__MYZS_ROOT}/resources"
export __MYZS_ZPLUG="${ZPLUG_HOME:-${__MYZS_ROOT}/zplug}"

export __MYZS_USER="${MYZS_USER:-$USER}"
export __MYZS_OWNER="Kamontat Chantrachirathumrong"
export __MYZS_VERSION="4.7.2"
export __MYZS_SINCE="21 Apr 2018"
export __MYZS_LAST_UPDATED="22 Aug 2020"
export __MYZS_LICENSE="MIT"
export __MYZS_MODULES=()
export __MYZS_FULLY_MODULES=(
  "app/android.sh"
  "app/docker.sh"
  "app/fzf.sh"
  "app/history.sh"
  "app/kube.sh"
  "app/myzs.sh"
  "app/tmux.sh"
  "app/wireshark.sh"
  "app/asdf.sh"
  "app/flutter.sh"
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

export __MYZS_CHANGELOGS=(
  "4.7.2" "22 Aug 2020"
  " - add new alias/project.sh modules for create new tmp project
 - include environment loading in progress bar
 - remove gc for git commit and use gcm for git commit
 - change gcod from dev branch to develop branch
 - fix linter in ggc command
 - cleanup output from myzs-info message
 - fix 'mload' didn't check modules name before load
 - add 'minfo' as alias of 'myzs-info'
 - add 'reshell' as alias of 'restart-shell'"
  "4.7.1" "10 Aug 2020"
  " - add short command as default enable modules"
  "4.7.0" "10 Aug 2020"
  " - reduce start time by loading only important modules
 - add myzs-load / mload for load modules after initial finish
 - alias all myzs-XXXXX command
 - reduce start time from ~7 seconds to ~2 seconds
 - add .myzs-setup file to automatic load when it present (configuable)
 - manually load .myzs-setup file by run myzs-setup-local command"
  "4.6.0" "10 Aug 2020"
  " - change logic to load modules
 - remove exclude module variable
 - add prefix to modules name
 - improve around 1% load time"
  "4.5.2" "13 Jul 2020"
  " - update alias of agoda and mac
 - update app of asdf and add new tmux app
 - add more helper in utils helper
 - update some minor config in init.sh"
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
__myzs_load_module "settings/system.sh" "${__MYZS_SOURCE_CODE}/settings/system.sh" || pg_mark_false "Cannot load system variable"

if __myzs_is_fully; then
  pg_mark "Commandline" "setup commandline settings"
  __myzs_load_module "settings/zsh.sh" "${__MYZS_SOURCE_CODE}/settings/zsh.sh" || pg_mark_false "Cannot load zsh settings"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "setup plugin manager"
  __myzs_load_module "zplug/init.zsh" "${__MYZS_ZPLUG}/init.zsh" || pg_mark_false "Cannot load zplug initial script"
fi

if __myzs_is_fully && __myzs_shell_is_zsh; then
  pg_mark "Plugin" "Loading plugins from zplug"
  __myzs_load_module "settings/plugins.sh" "${__MYZS_SOURCE_CODE}/settings/plugins.sh" || pg_mark_false "Cannot load zplug plugins list"

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

pg_mark "Helper" "Loading setup scripts"
for __path in "${MYZS_LOADING_MODULES[@]}"; do
  pg_mark "Scripts" "Loading $__path"

  fullpath="${__MYZS_SOURCE_CODE}/${__path}"

  # supported components
  if __myzs__is_valid_module "$__path"; then
    if __myzs_is_fully || [[ $__path =~ "alias" ]]; then
      __myzs_load_module "${__path}" "$fullpath" || pg_mark_false "Cannot load $__path"
    else
      pg_mark_false "non-alias modules cannot autoload in TYPE=$__MYZS_TYPE"
    fi
  else
    pg_mark_false "'$__path' not found in FULLY_COMPONENTS"
  fi
done

pg_mark "Helper" "Normalize all modules status"
for __component in "${__MYZS_FULLY_MODULES[@]}"; do
  if ! [[ "${MYZS_LOADING_MODULES[*]}" =~ $__component ]]; then
    fullpath="${__MYZS_SOURCE_CODE}/${__component}"
    __myzs_skip_module "${__component}" "$fullpath"
  fi
done

pg_mark "Helper" "Loading environment variable"
env_list=()
export __MYZS_ENVFILE="$MYZS_ROOT/.env"

__myzs_initial "$__MYZS_ENVFILE"
while IFS= read -r line; do
  key="${line%=*}"
  value="${line##*=}"

  if __myzs_is_string_exist "$key" && __myzs_is_string_exist "$value"; then
    env_list+=("$key")
    # shellcheck disable=SC2163
    export "${key}"="${value}"
  fi
done <"$__MYZS_ENVFILE"
[[ ${#env_list[@]} -gt 0 ]] && __myzs_info "exporting [ ${env_list[*]} ]"

pg_stop

__myzs_initial "$0"
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

$MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL && myzs-setup-local

__myzs_cleanup

export __MYZS_FINISH_TIME
__MYZS_FINISH_TIME="$(date +"%d/%m/%Y %H:%M:%S")"
