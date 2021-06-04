# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export PG_RESET="\033[0m"

export __MYZS__PG_PROCESS_COUNT=1
if _myzs:internal:setting:is-disabled "pb"; then
  export ____MYZS__REVOLVER_CMD="${__MYZS__SRC}/utils/revolver-mock"
else
  export ____MYZS__REVOLVER_CMD="${__MYZS__REVOLVER_CMD:-${__MYZS__SRC}/utils/revolver}"
fi

# get current time in millisecond
_myzs:pg:private:time:ms() {
  _myzs:internal:timestamp-millisecond
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
  printf "[ %-$(myzs:setting:get "pb/title/length")s ] %s" "$title" "$message"
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

  if _myzs:internal:setting:less-than "pb/timer/danger-color" "$raw_time"; then
    time_color="$(myzs:setting:get "pb/color/time-danger")"
  elif _myzs:internal:setting:less-than "pb/timer/warn-color" "$raw_time"; then
    time_color="$(myzs:setting:get "pb/color/time-warn")"
  else
    time_color="$(myzs:setting:get "pb/color/time")"
  fi

  printf "${color}[%s]${PG_RESET} %-$(myzs:setting:get "pb/message/length")s done in ${time_color}%s${PG_RESET}." "$symbol" "$message" "$dur"
}

_myzs:pg:private:log:completed() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pb/color/completed")" "+" "$dur" "$message"
}

_myzs:pg:private:log:skipped() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pb/color/skipped")" "*" "$dur" "$message"
}

_myzs:pg:private:log:failured() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pb/color/failed")" "-" "$dur" "$message"
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

export PG_PREV_TIME

export PG_PREV_MSG
PG_PREV_MSG=$(_myzs:pg:private:message:format "Start" "Initialization")

export PG_PREV_STATE
PG_PREV_STATE="C" # C = completed, F = failured, S = skipped

myzs:pg:start() {
  local message
  message="${1:-Initialization shell. Please Wait...}"
  "${____MYZS__REVOLVER_CMD}" -s "$(myzs:setting:get "pb/style" "dots")" start "$(myzs:setting:get "pb/color/loading")${message}"

  PG_START_TIME="$(_myzs:pg:private:time:ms)"
  PG_PREV_TIME="$(_myzs:pg:private:time:ms)"
}

myzs:pg:mark() {
  TIME=$(($(_myzs:pg:private:time:ms) - PG_PREV_TIME))

  "${____MYZS__REVOLVER_CMD}" -s "$(myzs:setting:get "pb/style" "dots")" update "$(myzs:setting:get "pb/color/loading")$2.."

  if _myzs:internal:setting:is-enabled "pb/performance"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  PG_PREV_TIME=$(_myzs:pg:private:time:ms)
  PG_PREV_MSG=$(_myzs:pg:private:message:format "$@")
  PG_PREV_STATE="C"
  ((__MYZS__PG_PROCESS_COUNT++))
}

myzs:pg:mark-fail() {
  PG_PREV_STATE="F"
  PG_PREV_MSG=$(_myzs:pg:private:message:format "Error" "$1")

  if ! _myzs:internal:setting:is-enabled "pb/performance"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi
}

myzs:pg:mark-skip() {
  PG_PREV_STATE="S"
  PG_PREV_MSG=$(_myzs:pg:private:message:format "Skip" "Skipping $1 component")
}

myzs:pg:stop() {
  local load_time count_varname="${1:-STARTUP_COUNT}" loadtime_varname="${2:-STARTUP_LOADTIME}"

  TIME=$(($(_myzs:pg:private:time:ms) - PG_PREV_TIME))

  if _myzs:internal:setting:is-enabled "pb/performance"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  "${____MYZS__REVOLVER_CMD}" stop

  TIME=$(($(_myzs:pg:private:time:ms) - PG_START_TIME))
  load_time="$(_myzs:pg:private:time:convert "${TIME}")"

  printf "$(myzs:setting:get "pb/color/completed")[+]${PG_RESET} %-$(myzs:setting:get "pb/message/length")s      in $(myzs:setting:get "pb/color/time")%s${PG_RESET}." "$(_myzs:pg:private:message:format "Completed" "Initialization $__MYZS__PG_PROCESS_COUNT tasks")" "${load_time}"
  echo

  export "$count_varname"="${__MYZS__PG_PROCESS_COUNT}"
  export "$loadtime_varname"="$load_time"
  # shellcheck disable=SC2140
  export "${loadtime_varname}_MS"="$TIME"

  unset PG_PREV_TIME PG_PREV_MSG PG_PREV_STATE
}

myzs:pg:cleanup() {
  unset TIME __MYZS__PG_PROCESS_COUNT PG_START_TIME

  __MYZS__PG_PROCESS_COUNT=1
}
