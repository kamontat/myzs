#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by create-script-file v4.0.1
# link (https://github.com/Template-generator/create-script-file/tree/v4.0.1)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -----------------------------------
#/ Custom:       This allow user custom how it work via environment variable
#/               1. $MZ_VERSION to specify version of the project
#/               2. $SHELL to specify shell file to link
#/               3. $MZ_PROTOCOL to specify git clone with https or ssh
#/ Steps:        1. clone the project
#/               2. link the file
#/ ------------------------------------------
#/ Create by:    Kamontat Chantrachirathumrong <developer@kamontat.net>
#/ Since:        10/09/2020
#/ ------------------------------------------
#/ Error code    1      -- error
#/ ------------------------------------------
#// Version:      1.0.0 -- create new script

start_cmd() {
  if [[ $MZ_DRYRUN == true ]]; then
    echo "[DBG] $*"
  else
    "$@"
  fi
}

ask() {
  export ANSWER

  local title="$1" msg="$2" def="$3"
  printf "%10s: %-25s [%-10s] -> " "$title" "$msg" "$def"
  read -r ANSWER

  test -z "$ANSWER" && ANSWER="$def"
}

ask_choice() {
  export ANSWER

  local title="$1" msg="$2" def="$3"
  shift 3
  local choices=("$@")
  printf "%10s: %-25s [%-10s] -> " "$title" "$msg" "$def"
  read -r ANSWER

  test -z "$ANSWER" && ANSWER="$def"

  if [[ "${choices[*]}" =~ $ANSWER ]]; then
    return 0
  else
    echo "'$ANSWER' is not listed in choices [${choices[*]}]" >&2
    exit 1
  fi
}

steps() {
  local number="$curr_step"
  local total="$total_steps"
  local name="$1"

  echo "[$number/$total] $name"
}

next_section() {
  echo
  echo '=============================================='
  echo
}

ask "Optional" "enter location" "${MZ_LOCATION:-$HOME/.myzs}"
MZ_LOCATION="$ANSWER"

ask "Optional" "enter specify version" "${MZ_VERSION:-master}"
MZ_VERSION="$ANSWER"

SHELL_NAME="$(basename "$SHELL")"
ask_choice "Optional" "enter specify shell" "${SHELL_NAME:-zsh}" "zsh" "bash"
SHELL_NAME="$ANSWER"
SHELLRC=".${SHELL_NAME}rc"

ask_choice "Optional" "enter clone protocol" "${MZ_PROTOCOL:-ssh}" "https" "ssh"
MZ_PROTOCOL="$ANSWER"

ask_choice "Optional" "is dryrun" "${MZ_DRYRUN:-false}" "true" "false"
MZ_DRYRUN="$ANSWER"

next_section

RC_PATH="$HOME/${SHELLRC}"
BACKUP_SUFFIX="-$(date +%s).backup"

total_steps="3"
curr_step="1"
test -d "$MZ_LOCATION" && ((total_steps++))
test -f "$RC_PATH" && ((total_steps++))

steps "Installing MYZS version ${MZ_VERSION} on ${SHELL_NAME}"
((curr_step++))

if test -d "$MZ_LOCATION"; then
  steps "Backup existing myzs directory"
  ((curr_step++))

  start_cmd mv "$MZ_LOCATION" "${MZ_LOCATION}${BACKUP_SUFFIX}"
fi

steps "Cloning myzs project to local machine"
((curr_step++))

git_url="git@github.com:kamontat/myzs.git"
[[ "$MZ_PROTOCOL" == "https" ]] && git_url="https://github.com/kamontat/myzs.git"
start_cmd git clone --recurse-submodules --branch "$MZ_VERSION" "$git_url" "$HOME/.myzs"

if test -f "$RC_PATH"; then
  steps "Backup existing .zshrc file"
  ((curr_step++))

  start_cmd mv -r "$RC_PATH" "${RC_PATH}${BACKUP_SUFFIX}"
fi

steps "Links zshrc file with root"
((curr_step++))

start_cmd ln -s "${MZ_LOCATION}/${SHELLRC}" "${RC_PATH}"
