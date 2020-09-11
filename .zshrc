# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

################################
# Application settings         #
################################

# Enable debug mode;
# export MYZS_DEBUG=true

# Your username. This will fallback to $USER with not specify
# export MYZS_USER="$USER"

# Copy path you would like to go, the start shell will try to cd to that path automatically
export MYZS_SETTINGS_AUTO_OPEN_PATH=true

# add trigger event to cd command to check .myzs-setup file
export MYZS_SETTINGS_AUTOLOAD_SETUP_LOCAL=false

# when checking auto setup file,
# it will use this list to file the exist file and load to enviroment
export MYZS_SETTINGS_SETUP_FILES=("myzs-setup" ".myzs-setup" ".myzs" "myzs")

# start command; this will run after exit init.sh
export MYZS_START_COMMAND=""
# start command arguments
export MYZS_START_COMMAND_ARGUMENTS=()

# Add welcome message everytime you open shell
export MYZS_SETTINGS_WELCOME_MESSAGE=""

# This is settings for myzs behavior.
# Accept only two value, either FULLY | SMALL.
# If you pass another value rather that two value above, the application may crash
export MYZS_TYPE="FULLY"

# This shouldn't be changes, except you install the application to difference
export MYZS_ROOT="$HOME/.myzs"

export MYZS_LOADING_MODULES=(
  "app/myzs.sh"
  # "app/myzs-git.sh"
  # "app/android.sh"
  # "app/docker.sh"
  # "app/fzf.sh"
  # "app/kube.sh"
  # "app/tmux.sh"
  # "app/wireshark.sh"
  # "app/asdf.sh"
  # "app/flutter.sh"
  # "app/gcloud.sh"
  # "app/go.sh"
  # "app/iterm.sh"
  # "app/macgpg.sh"
  # "app/thefuck.sh"
  # "app/travis.sh"
  # "app/yarn.sh"
  "alias/initial.sh"
  "alias/myzs.sh"
  # "alias/agoda.sh"
  # "alias/docker.sh"
  # "alias/fuck.sh"
  "alias/git.sh"
  "alias/mac.sh"
  "alias/shell.sh"
  # "alias/vim.sh"
  # "alias/coreutils.sh"
  "alias/editor.sh"
  # "alias/generator.sh"
  # "alias/github.sh"
  # "alias/neofetch.sh"
  "alias/short.sh"
  # "alias/yarn.sh"
)

################################
# Dependenies settings         #
################################

# If this is true, the application will trace each component in difference lines
export MYZS_PG_SHOW_PERF=false
# minimum millisecond will be shown as danger color
export MYZS_PG_TIME_THRESHOLD_MS=500

# loading message color
export MYZS_PG_LOADING_CL=""

# complete status indicator
export MYZS_PG_COMPLETE_CL=""
# skip status indicator
export MYZS_PG_SKIP_CL=""
# fail status indicator
export MYZS_PG_FAIL_CL=""

# time danger
export MYZS_PG_DANGER_CL=""
# normal time color
export MYZS_PG_TIME_CL=""

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
