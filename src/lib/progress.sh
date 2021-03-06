# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

export PG_RESET="\033[0m"

export __MYZS__PG_PROCESS_COUNT=1
if _myzs:internal:setting:is-disabled "pg"; then
  export ____MYZS__REVOLVER_CMD="${__MYZS__LIB}/revolver-mock"
else
  export ____MYZS__REVOLVER_CMD="${__MYZS__REVOLVER_CMD:-${__MYZS__LIB}/revolver}"
fi

# convert millisecond to string
_myzs:pg:private:time:convert() {
  ! $PG_FORMAT_TIME && echo "$1" && return 0

  local ms="$1" time_format
  time_format="$(myzs:setting:get "pg/timer/format")"

  local total_minute total_second total_millisecond
  total_minute="$(printf '%01dm' "$((ms / 60000))")"
  total_second="$(printf '%01ds' "$((ms / 1000))")"
  total_millisecond="$(printf '%01dms' "$ms")"

  second="$(printf '%02ds' "$((ms % 60000 / 1000))")" # time in seconds in 1 minute
  millisecond="$(printf '%03dms' "$((ms % 1000))")"   # time in millisecond in 1 second

  output="$time_format"
  output="${output/\%M/$total_minute}"      # total minute is %M
  output="${output/\%S/$total_second}"      # total second is %S
  output="${output/\%L/$total_millisecond}" # total millisecond is %L
  output="${output/\%s/$second}"            # second is %s
  output="${output/\%l/$millisecond}"       # second is %l

  printf '%s' "$output"
}

# convert input to log message format
_myzs:pg:private:message:format() {
  local title="$1"
  shift
  local message="$*"
  printf "[ %-$(myzs:setting:get "pg/title/length")s ] %s" "$title" "$message"
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

  if _myzs:internal:setting:less-than "pg/timer/danger-color" "$raw_time"; then
    time_color="$(myzs:setting:get "pg/color/time-danger")"
  elif _myzs:internal:setting:less-than "pg/timer/warn-color" "$raw_time"; then
    time_color="$(myzs:setting:get "pg/color/time-warn")"
  else
    time_color="$(myzs:setting:get "pg/color/time")"
  fi

  printf "${color}[%s]${PG_RESET} %-$(myzs:setting:get "pg/message/length")s done in ${time_color}%s${PG_RESET}." "$symbol" "$message" "$dur"
}

_myzs:pg:private:log:completed() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pg/color/completed")" "+" "$dur" "$message"
}

_myzs:pg:private:log:skipped() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pg/color/skipped")" "*" "$dur" "$message"
}

_myzs:pg:private:log:failured() {
  local dur="$1"
  shift
  local message="$*"

  _myzs:pg:private:message "$(myzs:setting:get "pg/color/failed")" "-" "$dur" "$message"
}

_myzs:pg:private:log() {
  if [[ "$1" == "C" ]]; then
    _myzs:pg:private:log:completed "$2" "$3"
  elif [[ "$1" == "F" ]]; then
    _myzs:pg:private:log:failured "$2" "$3"
  elif [[ "$1" == "S" ]]; then
    _myzs:pg:private:log:skipped "$2" "$3"
  else
    return 0
  fi
  echo
}

export PG_START_TIME
export PG_PREV_TIME
export PG_PREV_MSG
PG_PREV_MSG=$(_myzs:pg:private:message:format "Start" "Initialization")

# unknown will occurred if you didn't call step* method before call mark* method
export PG_PREV_STATE
PG_PREV_STATE="C" # C = completed, F = failured, S = skipped, U = unknown

myzs:pg:start() {
  local message
  message="${1:-Initialization shell. Please Wait...}"
  "${____MYZS__REVOLVER_CMD}" -s "$(myzs:setting:get "pg/style" "dots")" start "$(myzs:setting:get "pg/color/loading")${message}"

  PG_START_TIME="$(_myzs:internal:timestamp-millisecond)"
  PG_PREV_TIME="$(_myzs:internal:timestamp-millisecond)"
}

myzs:pg:private:mark() {
  local state="$1"
  shift

  # calculate load time
  TIME=$(($(_myzs:internal:timestamp-millisecond) - PG_PREV_TIME))

  # always print data if state is return failure, otherwise print only performance is enabled
  if _myzs:internal:setting:is-enabled "pg/performance"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  elif [[ "$PG_PREV_STATE" == "F" ]]; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  # assign new time
  PG_PREV_TIME=$(_myzs:internal:timestamp-millisecond)
  # assign current steps
  PG_PREV_MSG=$(_myzs:pg:private:message:format "$@")
  # assign current state
  PG_PREV_STATE="$state"
  # update counter
  ((__MYZS__PG_PROCESS_COUNT++))
}

# start normal step
myzs:pg:step() {
  "${____MYZS__REVOLVER_CMD}" -s "$(myzs:setting:get "pg/style" "dots")" update "$(myzs:setting:get "pg/color/loading")$2.."
  myzs:pg:private:mark "C" "$@"
}

# modified msg of current step
myzs:pg:msg() {
  PG_PREV_MSG=$(_myzs:pg:private:message:format "$@")
}

# start skipping step
myzs:pg:step-skip() {
  local title="$1"
  shift

  "${____MYZS__REVOLVER_CMD}" -s "$(myzs:setting:get "pg/style" "dots")" update "$(myzs:setting:get "pg/color/loading")$2.."
  myzs:pg:private:mark "S" "$title" "Skipped: $*"
}

# mark current step as fail
myzs:pg:mark-fail() {
  PG_PREV_STATE="F" # override previous step to failure
  PG_PREV_MSG=$(_myzs:pg:private:message:format "$@")

  myzs:pg:private:mark "U" "Unknown" "Your code has something wrong"
}

myzs:pg:stop() {
  local load_time count_varname="${1:-STARTUP_COUNT}" loadtime_varname="${2:-STARTUP_LOADTIME}"

  TIME=$(($(_myzs:internal:timestamp-millisecond) - PG_PREV_TIME))

  if _myzs:internal:setting:is-enabled "pg/performance"; then
    _myzs:pg:private:log "$PG_PREV_STATE" "$TIME" "$PG_PREV_MSG"
  fi

  "${____MYZS__REVOLVER_CMD}" stop

  TIME=$(($(_myzs:internal:timestamp-millisecond) - PG_START_TIME))
  load_time="$(_myzs:pg:private:time:convert "${TIME}")"

  printf "$(myzs:setting:get "pg/color/completed")[+]${PG_RESET} %-$(myzs:setting:get "pg/message/length")s      in $(myzs:setting:get "pg/color/time")%s${PG_RESET}." "$(_myzs:pg:private:message:format "Done" "Initialization $__MYZS__PG_PROCESS_COUNT tasks")" "${load_time}"
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
