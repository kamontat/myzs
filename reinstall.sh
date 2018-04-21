#!/usr/bin/env bash

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -------------------------------------------------
#/ Description:  ...
#/ Create by:    ...
#/ Since:        ...
#/ -------------------------------------------------
#/ Version:      0.0.1  -- description
#/               0.0.2b -- beta-format
#/ -------------------------------------------------
#/ Error code    1      -- error
#/ -------------------------------------------------
#/ Bug:          ...
#/ -------------------------------------------------

cd "$(dirname "$0")" || exit 1

help() {
	cat "reinstall.sh" | grep "^#/" | tr -d "#/ "
}

# -------------------------------------------------
# App logic
# -------------------------------------------------

if [ "$1" == "help" ] ||
	[ "$1" == "--help" ] ||
	[ "$1" == "h" ] ||
	[ "$1" == "-h" ] ||
	[ "$1" == "?" ] ||
	[ "$1" == "-?" ]; then
	help "$0" && exit
fi

test -f "install.sh" || echo "install script is   require!"
test -f "uninstall.sh" || echo "uninstall script is require!"

echo "UNINSTALL..."
./uninstall.sh
echo "INSTALL..."
./install.sh
