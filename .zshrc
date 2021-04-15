# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

################################
# Application settings         #
################################

# Enable debug mode;
# export MYZS_DEBUG=true

# add trigger event to cd command to check .myzs-setup file
export MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL=true

# when checking auto setup file,
# it will use this list to file the exist file and load to enviroment
export MYZS_SETTINGS_SETUP_FILES=("myzs-setup" ".myzs-setup")

# This shouldn't be changes, except you install the application to difference
export MYZS_ROOT="$HOME/.myzs"

# List of enabled log level, this is case insensitive
# export MYZS_LOG_LEVEL=("error" "warn" "info" "debug")
export MYZS_LOG_LEVEL=("error" "warn")

export MYZS_LOADING_PLUGINS=(
  "myzs-plugins/core#master"
  "myzs-plugins/git#master"
  "myzs-plugins/editor#master"
  "myzs-plugins/macos#master"
  "kamontat/mplugin-agoda#master"
)

export MYZS_LOADING_MODULES=(
  "builtin#app/myzs.sh"
  "builtin#alias/myzs.sh"
  "builtin#alias/initial.sh"
)

MYZS_LOADING_MODULES+=(
  "myzs-plugins/editor#app/vscode.sh"
  "myzs-plugins/core#alias/short.sh"
  "myzs-plugins/core#alias/shell.sh"
  "myzs-plugins/git#alias/git.sh"
)

# Format
# first element must be '$'
# second element is command type
#   1. setup    => setup "$1" "$2"  (run $1=$2)
#   2. enabled  => enabled "$1"     (run $1=true)
#   3. disabled => disabled "$1"    (run $1=false)
export MYZS_LOADING_SETTINGS=(
  # This is settings for myzs behavior.
  # Accept values: FULLY | SMALL
  #   1. FULLY -> full command with advance support on zsh script
  #   2. SMALL -> small utils with alias for bash and server bash
  "$" setup myzs/type "FULLY"

  # Copy path you would like to go, the start shell will try to cd to that path automatically
  "$" enabled path/auto-open

  # Disable progress bar
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
  "$" enabled metrics
)

################################
# Zsh dependencies plugins     #
################################

## Override zplug plugins list.
## NOTES: This will remove all plugins from src/settings/plugins.sh except 'zplug/zplug'
## Uncommand function below
# export myzs:zplug:plugin-list
# myzs:zplug:plugin-list() {
#   zplug "zsh-users/zsh-autosuggestions"
# }

# Uncommand this, to use custom zplug application.
# export MYZS_ZPLUG=""

################################
# Zsh settings                 #
################################

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

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
