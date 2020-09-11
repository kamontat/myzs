#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by create-script-file v4.0.1
# link (https://github.com/Template-generator/create-script-file/tree/v4.0.1)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -----------------------------------
#/ Custom:       This allow user custom how it work via environment variable
#/               1. $VERSION to specify version of the project
#/               2. $SHELL to specify shell file to link
#/ Steps:        1. clone the project
#/               2. link the file
#/ ------------------------------------------
#/ Create by:    Kamontat Chantrachirathumrong <developer@kamontat.net>
#/ Since:        10/09/2020
#/ ------------------------------------------
#/ Error code    1      -- error
#/ ------------------------------------------
#// Version:      1.0.0 -- create new script

# move to script directory

# Option 1
cd "$(dirname "$0")" || exit 1

# Option 2
# cd "$(dirname "$(realpath "$0")")" || exit 1

# Option 3
# handle symlink
# real="$0"
# [ -h "$real" ] && real="$(readlink "$real")"
# cd "$(dirname "$real")" || exit 1

help() {
  grep "^#/ " "global.sh" | sed 's/#\/ //g'
}

# [[ "$1" == "--help" ]] ||
#   [[ "$1" == "-h" ]] ||
#   [[ "$1" == "-?" ]] ||
#   [[ "$1" == "help" ]] ||
#   [[ "$1" == "h" ]] ||
#   [[ "$1" == "?" ]] &&
#   help && exit 0

version() {
  grep "^#// " "global.sh" | sed 's/#\/\/ //g'
}

# [[ "$1" == "--version" ]] ||
#   [[ "$1" == "-v" ]] ||
#   [[ "$1" == "version" ]] ||
#   [[ "$1" == "v" ]] &&
#   version && exit 0

# @helper
throw() {
	printf '%s\n' "$1" >&2 && is_integer "$2" && exit "$2"
	return 0
}

# @helper
throw_if_empty() {
	local text="$1"
	test -z "$text" && throw "$2" "$3"
	return 0
}

# @option
require_argument() {
	throw_if_empty "$LONG_OPTVAL" "'$LONG_OPTARG' require argument" 9
}

# @option
no_argument() {
	[[ -n $LONG_OPTVAL ]] && ! [[ $LONG_OPTVAL =~ "-" ]] && throw "$LONG_OPTARG don't have argument" 9
	OPTIND=$((OPTIND - 1))
}

# @syscall
set_key_value_long_option() {
	if [[ $OPTARG =~ "=" ]]; then
		LONG_OPTVAL="${OPTARG#*=}"
		LONG_OPTARG="${OPTARG%%=$LONG_OPTVAL}"
	else
		LONG_OPTARG="$OPTARG"
		LONG_OPTVAL="$1"
		OPTIND=$((OPTIND + 1))
	fi
}

load_option() {
	while getopts 'Hh?Vv-:' flag; do
		case "${flag}" in
		H) help && exit 0 ;;
		h) help && exit 0 ;;
		\\?) help && exit 0 ;;
		V) version && exit 0 ;;
		v) version && exit 0 ;;
		-)
			export LONG_OPTARG
			export LONG_OPTVAL
			NEXT="${!OPTIND}"
			set_key_value_long_option "$NEXT"
			case "${OPTARG}" in
			help)
				no_argument
				help
				exit 0
				;;
			version)
				no_argument
				version
				exit 0
				;;
			*)
				# because optspec is assigned by 'getopts' command
				# shellcheck disable=SC2154
				if [ "$OPTERR" == 1 ] && [ "${optspec:0:1}" != ":" ]; then
					echo "Unexpected option '$LONG_OPTARG', run --help for more information" >&2
					exit 9
				fi
				;;
			esac
			;;
		?)
			echo "Unexpected option, run --help for more information" >&2
			exit 10
			;;
		*)
			echo "Unexpected option $flag, run --help for more information" >&2
			exit 10
			;;
		esac
	done
}

# load_option "$@"

