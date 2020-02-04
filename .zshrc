# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

##############################
# Application settings       #
##############################

# Enable debug mode;
# export MYZS_DEBUG=true

# custom user variable
export MYZS_USER="kamontat"

export MYZS_SETTINGS_AUTO_OPEN_PATH=true
# export MYZS_SETTINGS_WELCOME_MESSAGE="hello, world"

export MYZS_TYPE="FULLY" # either FULLY | SMALL

export MYZS_ROOT=$HOME/.myzs

##############################
# Dependenies settings       #
##############################

export PG_SHOW_PERF=false

export ZPLUG_HOME="${MYZS_ROOT}/zplug"

##############################
# Shell environment variable #
##############################

export SHELL="/usr/local/bin/zsh"

if test -f "${MYZS_ROOT}/init.sh"; then
  source "${MYZS_ROOT}/init.sh"
else
  echo "cannot load myzs init file" >&2
fi
