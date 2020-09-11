# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0" "force"

# Theme setting
export PG_RED="\033[1;31m"
export PG_GREEN="\033[1;32m"
export PG_YELLOW="\033[1;33m"
export PG_RESET="\033[0m"

# loading message color
export MYZS_PG_LOADING_CL="${MYZS_PG_LOADING_CL:-$PG_GREEN}"

# complete status indicator
export MYZS_PG_COMPLETE_CL="${MYZS_PG_COMPLETE_CL:-$PG_GREEN}"
# skip status indicator
export MYZS_PG_SKIP_CL="${MYZS_PG_SKIP_CL:-$PG_YELLOW}"
# fail status indicator
export MYZS_PG_FAIL_CL="${MYZS_PG_FAIL_CL:-$PG_RED}"

# time danger
export MYZS_PG_DANGER_CL="${MYZS_PG_DANGER_CL:-$PG_RED}"
# normal time color
export MYZS_PG_TIME_CL="${MYZS_PG_TIME_CL:-$PG_YELLOW}"

# Progress setting
export __PG_STYLE="${PG_STYLE:-shark}"

export __MYZS_PG_SHOW_PERF="${MYZS_PG_SHOW_PERF:-true}"

export MESSAGE_LENGTH=55
export PG_PROCESS_COUNT=1

export ____MYZS__REVOLVER_CMD="${__MYZS__REVOLVER_CMD:-./revolver}"

# get current time in millisecond
_myzs:pg:private:time:ms() {
  if command -v "gdate" &>/dev/null; then
    gdate +%s%3N
  else
    date +%s000
  fi
}

# convert millisecond to string
_myzs:pg:private:time:convert() {
  ! $PG_FORMAT_TIME && echo "$1" && return 0

  local ms="$1"
  printf '%0dm:%0ds:%0dms' $((ms / 60000)) $((ms % 60000 / 1000)) $((ms % 1000))
}

# convert input to log message format
_myzs:pg:private:message:format() {
  local title="$1"
  shift
  local message="$*"
  printf "[ %-13s ] %s" "$title" "$message"
}

# create full output message
_myzs:pg:private:message() {
  local color symbol raw_time dur message time_color

  color="$1"
  symbol="$2"
  raw_time="$3"
  shift 3

  dur="$(_myzs:pg:private:time:convert "${raw_time}")"
  message="$*"

  if ((raw_time > MYZS_PG_TIME_THRESHOLD_MS)); then
    time_color=${MYZS_PG_DANGER_CL}
  else
    time_color=${MYZS_PG_TIME_CL}
  fi

  printf "${color}[%s]${PG_RESET} %-${MESSAGE_LENGTH}s done in ${time_color}%s${PG_RESET}." "$symbol" "$message" "$dur"

}

_myzs:pg:private:log:completed() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$MYZS_PG_COMPLETE_CL" "+" "$dur" "$message"
}

_myzs:pg:private:log:skipped() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$MYZS_PG_SKIP_CL" "*" "$dur" "$message"
}

_myzs:pg:private:log:failured() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$MYZS_PG_FAIL_CL" "-" "$dur" "$message"
}

_myzs:pg:private:log() {
  if [[ "$1" == "C" ]]; then
    _myzs:pg:private:log:completed "$2" "$3"
  elif [[ "$1" == "F" ]]; then
    _myzs:pg:private:log:failured "$2" "$3"
  elif [[ "$1" == "S" ]]; then
    _myzs:pg:private:log:skipped "$2" "$3"
  fi
  echo
}

export PG_START_TIME
PG_START_TIME="$(_myzs:pg:private:time:ms)"

export PG_PREV_TIME
PG_PREV_TIME="$(_myzs:pg:private:time:ms)"

export PG_PREV_MSG
PG_PREV_MSG=$(_myzs:pg:private:message:format "Start" "Initialization")

export PG_PREV_STATE
PG_PREV_STATE="C" # C = completed, F = failured, S = skipped

myzs:pg:start() {
  local message
  message="${1:-Initialization shell. Please Wait...}"
  "${____MYZS__REVOLVER_CMD}" -s "$__PG_STYLE" start "${MYZS_PG_LOADING_CL}${message}"
}

myzs:pg:mark() {
  TIME=$(($(_myzs:pg:private:time:ms) - PG_PREV_TIME))

  "${____MYZS__REVOLVER_CMD}" -s "$__PG_STYLE" update "${MYZS_PG_LOADING_CL}$2.."

  if [[ "$__MYZS_PG_SHOW_PERF" == "true" ]]; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  PG_PREV_TIME=$(_myzs:pg:private:time:ms)
  PG_PREV_MSG=$(_myzs:pg:private:message:format "$@")
  PG_PREV_STATE="C"
  ((PG_PROCESS_COUNT++))
}

myzs:pg:mark-fail() {
  PG_PREV_STATE="F"
  PG_PREV_MSG=$(_myzs:pg:private:message:format "Error" "$1")
}

myzs:pg:mark-skip() {
  PG_PREV_STATE="S"
  PG_PREV_MSG=$(_myzs:pg:private:message:format "Skip" "Skipping $1 component")
}

myzs:pg:stop() {
  local load_time

  TIME=$(($(_myzs:pg:private:time:ms) - PG_PREV_TIME))

  if "$__MYZS_PG_SHOW_PERF"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  "${____MYZS__REVOLVER_CMD}" stop

  TIME=$(($(_myzs:pg:private:time:ms) - PG_START_TIME))
  load_time="$(_myzs:pg:private:time:convert "${TIME}")"

  printf "${MYZS_PG_COMPLETE_CL}[+]${PG_RESET} %-${MESSAGE_LENGTH}s      in ${MYZS_PG_TIME_CL}%s${PG_RESET}." "$(_myzs:pg:private:message:format "Completed" "Initialization $PG_PROCESS_COUNT tasks")" "${load_time}"
  echo

  export PROGRESS_LOADTIME="$load_time"
  export PROGRESS_LOADTIME_MS="$TIME"

  unset PG_PREV_TIME PG_PREV_MSG PG_PREV_STATE
}
