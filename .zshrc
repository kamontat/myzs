# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE
# zmodload zsh/zprof # enable profiling

################################
# Core setup                   #
################################

# This shouldn't be changes, except you install the application to difference
export MYZS_ROOT="$HOME/.myzs"
export MYZS_TYPE="FULLY"

################################
# Plugins and Modules          #
################################

export MYZS_LOADING_PLUGINS=(
  "myzs-plugins/core#master"
  "myzs-plugins/editor#master"
  "myzs-plugins/git#master"
  "myzs-plugins/macos#master"

  "myzs-plugins/thefuck#master"
  "myzs-plugins/mobile#main"
  "myzs-plugins/asdf#main"
  "myzs-plugins/google#main"
  "myzs-plugins/docker#master"

  "myzs-plugins/pack#main"
  "myzs-plugins/python#main"
  "myzs-plugins/golang#main"
  "myzs-plugins/nodejs#master"

  # "kamontat/mplugin-kamontat#master"
  # "kamontat/mplugin-agoda#master"
)

export MYZS_LOADING_MODULES=(
  "builtin#app/myzs.sh" # requires
  "builtin#alias/myzs.sh"

  "builtin#app/myzs-dev.sh" # several command for start myzs debugger

  "builtin#app/env.sh"      # loading .env file in .myzs directory
  "builtin#app/autopath.sh" # move to path from clipboard if folder is exist
)

MYZS_LOADING_MODULES+=(
  "myzs-plugins/core#alias/short.sh"
  # "myzs-plugins/core#alias/shell.sh"
  # "myzs-plugins/editor#app/vscode.sh"
  # "myzs-plugins/git#alias/git.sh"
)

# custom define group
# This will by loaded only if group setting is enabled
export MYZS_LOADING_GROUPS=(
  "$" group "shell" "myzs-plugins/core#alias/shell.sh"
  "$" group "dev" "myzs-plugins/editor#app/vscode.sh" "myzs-plugins/git#alias/git.sh" "myzs-plugins/thefuck#app/fuck.sh"
  "$" group "docker" "myzs-plugins/docker#alias/docker.sh" "myzs-plugins/pack#app/main.sh"
  "$" group "golang" "builtin#groups/dev" "myzs-plugins/git#alias/git.sh" "myzs-plugins/golang#app/go.sh"
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
  "$" string type "${MYZS_TYPE:-FULLY}"

  # enabled or disabled zplug modules and plugins
  # for custom plugins look to `Zsh dependencies plugins` section
  "$" enabled zplug

  # We will if plugin have loaded before, we will skip it
  # if disabled is setting we will process every plugin
  "$" enabled plugin/cache

  # Enabled this meaning progressbar step when we load plugin to be one 1 task
  "$" enabled plugin/aggregation

  # Enabled this meaning progressbar step when we load plugin to be one 1 task
  "$" enabled module/aggregation

  # List of enabled log level, this is case insensitive
  # "error" "warn" "info" "debug"
  "$" array logger/level "error"

  # enabled or disabled progress bar
  "$" enabled pg
  # If this is true, the application will trace each component in difference lines
  "$" disabled pg/performance
  # progress bar style (listed at src/utils/revolver)
  "$" string pg/style "bouncingBall"
  # title shift when price progress bar
  "$" string pg/title/length "8"
  # full message shift when print progress bar
  "$" string pg/message/length "68"
  # timer format in progressbar
  # %M - total minute, %S - total second, %L - total millisecond
  # %s - second, %l - millisecond
  "$" string pg/timer/format "%S:%l"
  # minimum millisecond will be shown as danger color
  "$" string pg/timer/danger-color "600"
  # minimum millisecond will be shown as warning color
  "$" string pg/timer/warn-color "200"
  # loading message color
  "$" string pg/color/loading "$(tput setaf 6)"
  # complete status indicator
  "$" string pg/color/completed "$(tput setaf 10)"
  # skip status indicator
  "$" string pg/color/skipped "$(tput setaf 11)"
  # fail status indicator
  "$" string pg/color/failed "$(tput setaf 9)"
  # time danger color
  "$" string pg/color/time-danger "$(tput setaf 1)"
  # time warning color
  "$" string pg/color/time-warn "$(tput setaf 3)"
  # normal time color
  "$" string pg/color/time "$(tput setaf 14)"

  # enabled module group (beta)
  "$" enabled group

  # enabled data metric (beta)
  "$" enabled metrics
)

################################
# Zsh dependencies plugins     #
################################

# Uncommand this, to use custom zplug application.
# export MYZS_ZPLUG=""

## Override zplug plugins list.
## NOTES: This will remove all plugins from src/settings/zplugins.sh except 'zplug/zplug'
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

# When enabled profiling
# zprof
