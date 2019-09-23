# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

# Theme setting
export PG_RED="\033[1;31m"
export PG_GREEN="\033[1;32m"
export PG_YELLOW="\033[1;33m"
export PG_RESET="\033[0m"

# Progress setting
export __PG_STYLE="${PG_STYLE:-shark}"

export __PG_SHOW_PERF="${PG_SHOW_PERF:-true}"

export MESSAGE_LENGTH=55
export PG_PROCESS_COUNT=1

export __REVOLVER_CMD="${REVOLVER_CMD:-./revolver}"

sec() {
  if command -v "gdate" &>/dev/null; then
    gdate +%s%3N
  else
    date +%s000
  fi
}

conv_time() {
  ! $PG_FORMAT_TIME && echo "$1" && return 0

  local ms="$1"
  printf '%0dm:%0ds:%0dms' $((ms / 60000)) $((ms % 60000 / 1000)) $((ms % 1000))
}

format_message() {
  local title="$1"
  shift
  local message="$*"
  printf "[ %-13s ] %s" "$title" "$message"
}

_message() {
  local color symbol raw_time dur message

  color="$1"
  symbol="$2"
  raw_time="$3"
  shift 3

  dur="$(conv_time "${raw_time}")"
  message="$*"

  printf "${color}[%s]${PG_RESET} %-${MESSAGE_LENGTH}s done in ${PG_YELLOW}%s${PG_RESET}." "$symbol" "$message" "$dur"
}

show_message_by() {
  if $1; then
    completed_message "$2" "$3"
  else
    failure_message "$2" "$3"
  fi
  echo
}

completed_message() {
  local dur="$1"
  shift
  local message="$*"

  _message "$PG_GREEN" "+" "$dur" "$message"
}

failure_message() {
  local dur="$1"
  shift
  local message="$*"

  _message "$PG_RED" "-" "$dur" "$message"
}

export PG_START_TIME
PG_START_TIME="$(sec)"

export PG_PREV_TIME
PG_PREV_TIME="$(sec)"

export PG_PREV_MSG
PG_PREV_MSG=$(format_message "Start" "Initialization")

export PG_PREV_STATE
PG_PREV_STATE=true

pg_start() {
  local message
  message="${1:-Initialization shell. Please Wait...}"
  "${__REVOLVER_CMD}" -s "$__PG_STYLE" start "${PG_GREEN}${message}"
}

pg_mark() {
  TIME=$(($(sec) - PG_PREV_TIME))

  "${__REVOLVER_CMD}" -s "$__PG_STYLE" update "${PG_GREEN}$2.."

  if [[ "$__PG_SHOW_PERF" == "true" ]]; then
    show_message_by "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  PG_PREV_TIME=$(sec)
  PG_PREV_MSG=$(format_message "$@")
  PG_PREV_STATE=true
  ((PG_PROCESS_COUNT++))
}

pg_mark_false() {
  PG_PREV_STATE=false
  PG_PREV_MSG=$(format_message "Error" "$1")
}

pg_stop() {
  TIME=$(($(sec) - PG_PREV_TIME))

  if "$__PG_SHOW_PERF"; then
    show_message_by "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  "${__REVOLVER_CMD}" stop

  TIME=$(($(sec) - PG_START_TIME))

  printf "${PG_GREEN}[+]${PG_RESET} %-${MESSAGE_LENGTH}s      in ${PG_YELLOW}%s${PG_RESET}." "$(format_message "Completed" "Initialization $PG_PROCESS_COUNT tasks")" "$(conv_time "${TIME}")"
  echo
}
