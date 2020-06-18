# shellcheck disable=SC1090,SC2148

__myzs_initial "$0" "force"

# Theme setting
export PG_RED="\033[1;31m"
export PG_GREEN="\033[1;32m"
export PG_YELLOW="\033[1;33m"
export PG_RESET="\033[0m"

# loading message color
export PG_LOADING_CL="${PG_LOADING_CL:-$PG_GREEN}"

# complete status indicator
export PG_COMPLETE_CL="${PG_COMPLETE_CL:-$PG_GREEN}"
# skip status indicator
export PG_SKIP_CL="${PG_SKIP_CL:-$PG_YELLOW}"
# fail status indicator
export PG_FAIL_CL="${PG_FAIL_CL:-$PG_RED}"

# time danger
export PG_DANGER_CL="${PG_DANGER_CL:-$PG_RED}"
# normal time color
export PG_TIME_CL="${PG_TIME_CL:-$PG_YELLOW}"

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
  local color symbol raw_time dur message time_color

  color="$1"
  symbol="$2"
  raw_time="$3"
  shift 3

  dur="$(conv_time "${raw_time}")"
  message="$*"

  if ((raw_time > PG_TIME_THRESHOLD_MS)); then
    time_color=${PG_DANGER_CL}
  else
    time_color=${PG_TIME_CL}
  fi

  printf "${color}[%s]${PG_RESET} %-${MESSAGE_LENGTH}s done in ${time_color}%s${PG_RESET}." "$symbol" "$message" "$dur"

}

show_message_by() {
  if [[ "$1" == "C" ]]; then
    completed_message "$2" "$3"
  elif [[ "$1" == "F" ]]; then
    failured_message "$2" "$3"
  elif [[ "$1" == "S" ]]; then
    skipped_message "$2" "$3"
  fi
  echo
}

completed_message() {
  local dur="$1"
  shift
  local message="$*"

  _message "$PG_COMPLETE_CL" "+" "$dur" "$message"
}

skipped_message() {
  local dur="$1"
  shift
  local message="$*"

  _message "$PG_SKIP_CL" "*" "$dur" "$message"
}

failured_message() {
  local dur="$1"
  shift
  local message="$*"

  _message "$PG_FAIL_CL" "-" "$dur" "$message"
}

export PG_START_TIME
PG_START_TIME="$(sec)"

export PG_PREV_TIME
PG_PREV_TIME="$(sec)"

export PG_PREV_MSG
PG_PREV_MSG=$(format_message "Start" "Initialization")

export PG_PREV_STATE
PG_PREV_STATE="C" # C = completed, F = failured, S = skipped

pg_start() {
  local message
  message="${1:-Initialization shell. Please Wait...}"
  "${__REVOLVER_CMD}" -s "$__PG_STYLE" start "${PG_LOADING_CL}${message}"
}

pg_mark() {
  TIME=$(($(sec) - PG_PREV_TIME))

  "${__REVOLVER_CMD}" -s "$__PG_STYLE" update "${PG_LOADING_CL}$2.."

  if [[ "$__PG_SHOW_PERF" == "true" ]]; then
    show_message_by "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  PG_PREV_TIME=$(sec)
  PG_PREV_MSG=$(format_message "$@")
  PG_PREV_STATE="C"
  ((PG_PROCESS_COUNT++))
}

pg_mark_false() {
  PG_PREV_STATE="F"
  PG_PREV_MSG=$(format_message "Error" "$1")
}

pg_mark_skip() {
  PG_PREV_STATE="S"
  PG_PREV_MSG=$(format_message "Skip" "Skipping $1 component")
}

pg_stop() {
  TIME=$(($(sec) - PG_PREV_TIME))

  if "$__PG_SHOW_PERF"; then
    show_message_by "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  "${__REVOLVER_CMD}" stop

  TIME=$(($(sec) - PG_START_TIME))

  printf "${PG_COMPLETE_CL}[+]${PG_RESET} %-${MESSAGE_LENGTH}s      in ${PG_TIME_CL}%s${PG_RESET}." "$(format_message "Completed" "Initialization $PG_PROCESS_COUNT tasks")" "$(conv_time "${TIME}")"
  echo
}
