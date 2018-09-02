# shellcheck disable=SC1090,SC2148

export PG_RED="\033[1;31m"
export PG_GREEN="\033[1;32m"
export PG_YELLOW="\033[1;33m"
export PG_RESET="\033[0m"

export PG_PROCESS_COUNT=1

sec() {
	if command -v "gdate" &>/dev/null; then
		gdate +%s%3N
	else
		echo "0"
	fi
}

conv_time() {
	! $PG_FORMAT_TIME && echo "$1" && return 0

	local ms="$1"
	printf '%0dm:%0ds:%0dms' $((ms / 60000)) $((ms % 60000/1000)) $((ms % 1000))
}

export PG_START_TIME
PG_START_TIME="$(sec)"

export PG_PREV_TIME
PG_PREV_TIME="$(sec)"

export PG_PREV_MSG
PG_PREV_MSG="Starting shell"

export PG_PREV_STATE
PG_PREV_STATE=true

pg_start() {
	"${MYZS_LIB}/revolver" -s 'dots' start "${PG_GREEN}Booting up shell. Please Wait..."
}

pg_mark() {
	TIME=$(($(sec) - PG_PREV_TIME))

	"${MYZS_LIB}/revolver" update "${PG_GREEN}$1.."

	if "$PG_SHOW_PERF_INFO"; then
		$PG_PREV_STATE &&
			printf "${PG_GREEN}[+]${PG_RESET} %-25s done in ${PG_YELLOW}%s${PG_RESET}." "${PG_PREV_MSG}" "$(conv_time "${TIME}")" ||
			printf "${PG_RED}[-]${PG_RESET} %-25s error in ${PG_YELLOW}%s${PG_RESET}." "${PG_PREV_MSG}" "$(conv_time "${TIME}")"
		echo
	fi

	PG_PREV_TIME=$(sec)
	PG_PREV_MSG=$1
	PG_PREV_STATE=true
	((PG_PROCESS_COUNT++))
}

pg_mark_false() {
	PG_PREV_STATE=false
	PG_PREV_MSG=$1
}

pg_stop() {
	TIME=$(($(sec) - PG_PREV_TIME))

	if "$PG_SHOW_PERF_INFO"; then
		$PG_PREV_STATE &&
			printf "${PG_GREEN}[+]${PG_RESET} %-25s done in ${PG_YELLOW}%s${PG_RESET}." "${PG_PREV_MSG}" "$(conv_time "${TIME}")" ||
			printf "${PG_RED}[-]${PG_RESET} %-25s error in ${PG_YELLOW}%s${PG_RESET}." "${PG_PREV_MSG}" "$(conv_time "${TIME}")"
		echo
	fi

	"${MYZS_LIB}/revolver" stop

	TIME=$(($(sec) - PG_START_TIME))

	printf "${PG_GREEN}[+]${PG_RESET} %-25s done in ${PG_YELLOW}%s${PG_RESET}." "Initialization ($PG_PROCESS_COUNT tasks)" "$(conv_time "${TIME}")"
	echo
}

export is_command_exist
is_command_exist() {
	command -v "$1" &>/dev/null
}
