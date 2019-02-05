#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  Install script
#/               To install script,
#/                 1. This will verify by validate checksum
#/                 2. This will copy this project to
#/                    $HOME/.myzs/ folder, this will fail if directory is exist
#/                 3. create symlink between '$HOME/.myzs/.zshrc' and '$HOME/.zshrc'
#/                    this will fail if file exist
#/ Create by:    Kamontat Chantrachirathumrong
#/ Since:        27/03/2018
#/ -------------------------------------------------
#/ Version:      0.0.1  -- add help command
#/               1.0.0  -- production
#/ -------------------------------------------------
#/ Error code    1      -- common error
#/ -------------------------------------------------
#/ Known bug:    not exist
#/ -------------------------------------------------

NAME=".myzs"
ZSHRC=".zshrc"

help() {
  local t="$PWD"
  cd "$(dirname "$0")" || return 1
  cat "install.sh" | grep "^#/" | tr -d "#/"
  cd "$t" || return 1
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

source "./progress.sh" || exit 2

# progressbar clone "Clone project" "none"
progressbar create_link "Link project" "$HOME"
