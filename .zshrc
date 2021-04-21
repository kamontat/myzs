# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

################################
# Core setup                   #
################################

# Enable debug mode;
# export MYZS_DEBUG=true

# This shouldn't be changes, except you install the application to difference
export MYZS_ROOT="$HOME/.myzs"

################################
# Plugins and Modules          #
################################

export MYZS_LOADING_PLUGINS=(
  "myzs-plugins/core#master"
  "myzs-plugins/editor#master"
  "myzs-plugins/git#master"
  # "myzs-plugins/macos#master"

  # "myzs-plugins/thefuck#master"
  # "myzs-plugins/nodejs#master"
  # "myzs-plugins/docker#master"
  # "kamontat/mplugin-kamontat#master"
  # "kamontat/mplugin-agoda#master"
)

export MYZS_LOADING_MODULES=(
  "builtin#app/myzs.sh"
  "builtin#alias/myzs.sh"
  "builtin#alias/initial.sh"
)

MYZS_LOADING_MODULES+=(
  "myzs-plugins/core#alias/short.sh"
  "myzs-plugins/core#alias/shell.sh"
  "myzs-plugins/editor#app/vscode.sh"
  "myzs-plugins/git#alias/git.sh"
)

MYZS_LOADING_MODULES+=(
  # "myzs-plugins/macos#app/coreutils.sh"
  # "myzs-plugins/macos#app/macgpg.sh"
  # "myzs-plugins/macos#app/macos.sh"
)

################################
# Application settings         #
################################

# Format
# first element must be '$'
# second element is command type
#   1. setup    => setup "$1" "$2"  (run $1=$2)
#   2. array    => array "$1" "$@"  (run $1=($2 $3 $@))
#   2. enabled  => enabled "$1"     (run $1=true)
#   3. disabled => disabled "$1"    (run $1=false)
export MYZS_LOADING_SETTINGS=(
  # This is settings for myzs behavior.
  # Accept values: FULLY | SMALL
  #   1. FULLY -> full command with advance support on zsh script
  #   2. SMALL -> small utils with alias for bash and server bash
  "$" setup myzs/type "${_MYZS_TYPE:-FULLY}"

  # enabled or disabled zplug modules and plugins
  # for custom plugins look to `Zsh dependencies plugins` section
  "$" enabled myzs/zplug

  # List of enabled log level, this is case insensitive
  # "error" "warn" "info" "debug"
  "$" array logger/level "error"

  # checking copy data. if it path go to that path automatically
  "$" enabled automatic/open-path

  # add trigger event to cd command to check .myzs-setup file
  "$" disabled setup-file/automatic
  # when checking auto setup file,
  # it will use this list to file the exist file and load to enviroment
  "$" array setup-file/list "myzs-setup" ".myzs-setup"

  # enabled or disabled progress bar
  "$" enabled pb
  # If this is true, the application will trace each component in difference lines
  "$" disabled pb/performance
  # progress bar style (listed at src/utils/revolver)
  "$" setup pb/style "bouncingBall"
  # full message shift when print progress bar
  "$" setup pb/message/length "68"
  # title shift when price progress bar
  "$" setup pb/title/length "15"
  # minimum millisecond will be shown as danger color
  "$" setup pb/timer/danger-color "600"
  # minimum millisecond will be shown as warning color
  "$" setup pb/timer/warn-color "200"
  # loading message color
  "$" setup pb/color/loading "$(tput setaf 6)"
  # complete status indicator
  "$" setup pb/color/completed "$(tput setaf 10)"
  # skip status indicator
  "$" setup pb/color/skipped "$(tput setaf 11)"
  # fail status indicator
  "$" setup pb/color/failed "$(tput setaf 9)"
  # time danger color
  "$" setup pb/color/time-danger "$(tput setaf 1)"
  # time warning color
  "$" setup pb/color/time-warn "$(tput setaf 3)"
  # normal time color
  "$" setup pb/color/time "$(tput setaf 14)"

  # enabled data metric
  "$" disabled metrics
)

################################
# Zsh dependencies plugins     #
################################

# Uncommand this, to use custom zplug application.
# export MYZS_ZPLUG=""

## Override zplug plugins list.
## NOTES: This will remove all plugins from src/settings/plugins.sh except 'zplug/zplug'
## Uncommand function below
# myzs:zplug:custom:plugin-list() {
#   zplug "zsh-users/zsh-autosuggestions"
# }

################################
# Shell environment variable   #
################################

# This is tell terminal to know what is default shell
# MYZS_DEFAULT_SHELL="/usr/local/bin/zsh"
# export MYZS_DEFAULT_SHELL

# System call, leave it alone
if test -f "${MYZS_ROOT}/init.sh"; then
  source "${MYZS_ROOT}/init.sh"
else
  echo "cannot load myzs init file" >&2
fi

################################
# Appending by user or scripts #
################################

# doing something

################################
#           Cleanup            #
################################

_myzs:internal:project:cleanup
