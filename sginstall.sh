#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by create-script-file v4.0.0
# link (https://github.com/Template-generator/create-script-file/tree/v4.0.0)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -----------------------------------
#/ Description:  Small installation, this will install only alias shortcut
#/ -----------------------------------
#/ Create by:    Kamontat Chantrachirathunrong <kamontat.c@hotmail.com>
#/ Since:        29/03/2019
#/ -----------------------------------
#/ Error code    1      -- error
#/ -----------------------------------
#//              1.0.0  -- first release

NAME=".myzs"

LOC_ZSHRC=".zshrc-small"
ZSHRC=".zshrc"

GIT_REPO="https://github.com/kamontat/myzs.git"

DEFAULT_VERSION="3.3.4"
VERSION="$([[ "$1" == "" ]] && echo "$DEFAULT_VERSION" || echo "$1")"

help() {
  local t="$PWD"
  cd "$(dirname "$0")" || return 1
  cat "install.sh" | grep "^#/" | tr -d "#/"
  cd "$t" || return 1
}

clone() {
  local folder="${HOME}/${NAME}"
  if test -d "$folder" || test -f "$folder"; then
    rm -rf "$folder"
  fi

  git clone --branch "$VERSION" "$GIT_REPO" "$folder" &>/dev/null
}

create_link() {
  local tmp="$PWD" exit_code=0
  cd "$1" || return 1

  local loc="${HOME}/${NAME}/${LOC_ZSHRC}"
  local rot="${HOME}/${ZSHRC}"

  if test -d "$rot" || test -f "$rot"; then
    mv "$rot" "$rot.before"
  fi

  ln -s "$loc" "$rot" || exit_code=$?
  cd "$tmp" || return 1
  return $exit_code
}

# -------------------------------------------------
# Constants
# -------------------------------------------------

if [ "$1" == "help" ] ||
  [ "$1" == "--help" ] ||
  [ "$1" == "h" ] ||
  [ "$1" == "-h" ] ||
  [ "$1" == "?" ] ||
  [ "$1" == "-?" ]; then
  help && exit
fi

cd "$(dirname "$0")" || exit 1 &>/dev/null

# 1. func -> execute function
# 2. name -> name of this execution
# n. value for each execution
progressbar() {
  local cmd="$1"
  local title="$2"
  shift 2
  IFS=" " read -r -a array <<<"$@"
  duration=$#

  curr_bar=0
  for ((elapsed = 1; elapsed <= duration; elapsed++)); do
    barsize=$(($(tput cols) - 25))
    unity=$((barsize / duration))
    increment=$((barsize % duration))
    skip=$((duration / (duration - increment)))
    # Elapsed
    ((curr_bar += unity))

    if [[ $increment -ne 0 ]]; then
      if [[ $skip -eq 1 ]]; then
        [[ $((elapsed % (duration / increment))) -eq 0 ]] && ((curr_bar++))
      else
        [[ $((elapsed % skip)) -ne 0 ]] && ((curr_bar++))
      fi
    fi

    [[ $elapsed -eq 1 && $increment -eq 1 && $skip -ne 1 ]] && ((curr_bar++))
    [[ $((barsize - curr_bar)) -eq 1 ]] && ((curr_bar++))
    [[ $curr_bar -lt $barsize ]] || curr_bar=$barsize

    printf "%-15s |" "$title"

    # Exection
    "$cmd" "${array[elapsed - 1]}" || exit $?

    # Progress
    for ((filled = 0; filled <= curr_bar; filled++)); do
      printf "#"
    done

    # Remaining
    for ((remain = curr_bar; remain < barsize; remain++)); do
      printf " "
    done

    # Percentage
    printf "| %s%%" $(((elapsed * 100) / duration))

    # Return
    printf '\r'
  done
  echo
}

progressbar clone "Clone project" "none"
progressbar create_link "Link project" "$HOME"
