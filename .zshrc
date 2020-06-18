# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

################################
# Application settings         #
################################

# Enable debug mode;
# export MYZS_DEBUG=true

# Your username, this shouldn't be change except you want coller name
export MYZS_USER="$USER"

# Copy path you would like to go, the start shell will try to cd to that path automatically
export MYZS_SETTINGS_AUTO_OPEN_PATH=true

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

export MYZS_EXCLUDE_COMPONENTS="travis.sh,fzf.sh,asdf.sh"

################################
# Dependenies settings         #
################################

# If this is true, the application will trace each component in difference lines
export PG_SHOW_PERF=false
# minimum millisecond will be shown as danger color
export PG_TIME_THRESHOLD_MS=300

# loading message color
export PG_LOADING_CL=""

# complete status indicator
export PG_COMPLETE_CL=""
# skip status indicator
export PG_SKIP_CL=""
# fail status indicator
export PG_FAIL_CL=""

# time danger
export PG_DANGER_CL=""
# normal time color
export PG_TIME_CL=""

################################
# Zsh dependencies plugins     #
################################

## Override zplug plugins list.
## NOTES: This will remove all plugins from src/settings/plugins.sh except 'zplug/zplug'
## Uncommand function below
# export myzs__plugins_list
# myzs__plugins_list() {
#   zplug "zsh-users/zsh-autosuggestions"
# }

# This shouldn't be changes, except you would like to use custom zplug
export ZPLUG_HOME="${MYZS_ROOT}/zplug"

################################
# Zsh settings                 #
################################

export HISTSIZE=1000000000
export SAVEHIST=$HISTSIZE

################################
# Shell environment variable   #
################################

# This is tell terminal to know what is default shell
DEFAULT_SHELL="/usr/local/bin/zsh"
export DEFAULT_SHELL

# System call, leave it alone
if test -f "${MYZS_ROOT}/init.sh"; then
  source "${MYZS_ROOT}/init.sh"
else
  echo "cannot load myzs init file" >&2
fi

################################
# Appending by user or scripts #
################################

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/usr/local/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/usr/local/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/usr/local/bin/google-cloud-sdk/completion.zsh.inc'; fi
