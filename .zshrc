# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

################################
# Core setup                   #
################################

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
  # "myzs-plugins/mobile#main"
  # "myzs-plugins/asdf#main"
  # "myzs-plugins/google#main"
  # "myzs-plugins/docker#master"

  # "myzs-plugins/python#main"
  # "myzs-plugins/golang#main"
  # "myzs-plugins/nodejs#master"

  # "kamontat/mplugin-kamontat#master"
  # "kamontat/mplugin-agoda#master"
)

export MYZS_LOADING_MODULES=(
  "builtin#app/myzs.sh" # requires

  # "builtin#alias/myzs.sh"
  # "builtin#app/autocd.sh" # add trigger event to cd command to check .myzs-setup file
  "builtin#app/env.sh" # loading .env file in .myzs directory
  # "builtin#app/group.sh" # generator module groups support (not works)
)

MYZS_LOADING_MODULES+=(
  "myzs-plugins/core#alias/short.sh"
  "myzs-plugins/core#alias/shell.sh"
  # "myzs-plugins/editor#app/vscode.sh"
  # "myzs-plugins/git#alias/git.sh"
)

MYZS_LOADING_MODULES+=(
  # "myzs-plugins/macos#app/coreutils.sh"
  # "myzs-plugins/macos#app/macgpg.sh"
  # "myzs-plugins/macos#app/macos.sh"
)

################################
# Application settings         #
################################

# Format action command will listed via `_myzs:private:setting:<name>`
# first element must be '$'
# second element is command type
#   1. string   => string "$1" "$2"  (run $1=$2)
#   2. array    => array "$1" "$@"  (run $1=($2 $3 $@))
#   2. enabled  => enabled "$1"     (run $1=true)
#   3. disabled => disabled "$1"    (run $1=false)
export MYZS_LOADING_SETTINGS=(
  # This is settings for myzs behavior.
  # Accept values: FULLY | SMALL
  #   1. FULLY -> full command with advance support on zsh script
  #   2. SMALL -> small utils with alias for bash and server bash
  "$" string myzs/type "${_MYZS_TYPE:-FULLY}"

  # enabled or disabled zplug modules and plugins
  # for custom plugins look to `Zsh dependencies plugins` section
  "$" enabled myzs/zplug

  # List of enabled log level, this is case insensitive
  # "error" "warn" "info" "debug"
  "$" array logger/level "error"

  # checking copy data. if it path go to that path automatically
  "$" enabled automatic/open-path

  # when checking auto setup file,
  # it will use this list to file the exist file and load to enviroment
  "$" array setup-file/list "myzs-setup" ".myzs-setup"

  # enabled or disabled progress bar
  "$" enabled pb
  # If this is true, the application will trace each component in difference lines
  "$" disabled pb/performance
  # progress bar style (listed at src/utils/revolver)
  "$" string pb/style "bouncingBall"
  # title shift when price progress bar
  "$" string pb/title/length "8"
  # full message shift when print progress bar
  "$" string pb/message/length "68"
  # minimum millisecond will be shown as danger color
  "$" string pb/timer/danger-color "600"
  # minimum millisecond will be shown as warning color
  "$" string pb/timer/warn-color "200"
  # loading message color
  "$" string pb/color/loading "$(tput setaf 6)"
  # complete status indicator
  "$" string pb/color/completed "$(tput setaf 10)"
  # skip status indicator
  "$" string pb/color/skipped "$(tput setaf 11)"
  # fail status indicator
  "$" string pb/color/failed "$(tput setaf 9)"
  # time danger color
  "$" string pb/color/time-danger "$(tput setaf 1)"
  # time warning color
  "$" string pb/color/time-warn "$(tput setaf 3)"
  # normal time color
  "$" string pb/color/time "$(tput setaf 14)"

  # enabled data metric (beta)
  "$" enabled metrics
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
