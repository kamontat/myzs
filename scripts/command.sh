#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  MYZS Setting command, This can be use for global install myzs, local install, and uninstall
#/               To Global install
#/                 1. run command.sh global [version]
#/                 2. after you run it will clone git repo and add to correct location
#/                 3. and link zshrc file to correct location required by zsh
#/               To Uninstall
#/                 1. run command.sh uninstall
#/                 1. This will remove all linked file and repository in $HOME/.myzs
#/ Create by:    Kamontat Chantrachirathumrong
#/ Since:        27/03/2018
#/ -------------------------------------------------
#/ Version:      0.0.1  -- add help command
#/               1.0.0  -- production
#/               1.1.0  -- change from install command to setup command
#/ -------------------------------------------------
#/ Error code    1      -- common error
#/ -------------------------------------------------
#/ Known bug:    to run install command, you must place repository on $HOME/.myzs, otherwise it will failed
#/ -------------------------------------------------

NAME=".myzs"
ZSHRC=".zshrc"

GIT_REPO="https://github.com/kamontat/myzs.git"

VERSION="${2:-4.8.0}"

help() {
  local t="$PWD"
  cd "$(dirname "$0")" || return 1
  cat "command.sh" | grep "^#/" | tr -d "#/"
  cd "$t" || return 1
}

clone() {
  local folder="${HOME}/${NAME}"
  if test -d "$folder" || test -f "$folder"; then
    rm -rf "$folder"
  fi

  git clone --recurse-submodules --branch "$VERSION" "$GIT_REPO" "$folder" &>/dev/null
}

create_link() {
  local tmp="$PWD" exit_code=0
  cd "$1" || return 1

  local loc="${HOME}/${NAME}/${ZSHRC}"
  local rot="${HOME}/${ZSHRC}"

  if test -d "$rot" || test -f "$rot"; then
    mv "$rot" "$rot.before"
  fi

  ln -s "$loc" "$rot" || exit_code=$?
  cd "$tmp" || return 1
  return $exit_code
}

delete() {
  local f="$1"
  rm -rf "$f" 2>/dev/null
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

if [[ "$1" == "global" ]]; then
  progressbar clone "Clone project" "none"
  progressbar create_link "Link project" "$HOME"
elif [[ "$1" == "install" ]]; then
  progressbar create_link "Link project" "$HOME"
elif [[ "$1" == "uninstall" ]]; then
  progressbar delete "Delete project" "${HOME}/.zshrc" "${HOME}/.myzs"
fi
