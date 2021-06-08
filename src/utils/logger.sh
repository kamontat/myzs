# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

export __MYZS__LOGTYPE="${MYZS_LOGTYPE:-auto}"
export __MYZS__LOGDIR="${MYZS_LOGDIR:-/tmp/myzs/logs}"
export __MYZS__LOGFILE="${MYZS_LOGFILE:-main.log}"
export __MYZS__ZPLUG_LOGFILE="${MYZS_ZPLUG_LOGFILE:-zplug.log}"

if [[ "$__MYZS__LOGTYPE" == "auto" ]]; then
  __MYZS__LOGFILE="main-$(date +"%y%m%d").log"
  __MYZS__ZPLUG_LOGFILE="zplug-$(date +"%y%m%d").log"
fi

export MYZS_LOGPATH="${__MYZS__LOGDIR}/${__MYZS__LOGFILE}"
export MYZS_ZPLUG_LOGPATH="${__MYZS__LOGDIR}/${__MYZS__ZPLUG_LOGFILE}"

_myzs:private:log() {
  local logger_level="$1"
  shift

  # cannot log if directory/file is not setup
  if [[ "$__MYZS__LOGDIR" == "" ]] || [[ $__MYZS__LOGFILE == "" ]]; then
    return 1
  fi

  if ! test -d "$__MYZS__LOGDIR"; then
    mkdir -p "$__MYZS__LOGDIR" >/dev/null
  fi

  if _myzs:internal:setting:contains "logger/level" "$logger_level"; then
    local datetime module_key

    datetime="$(date)"
    if [[ "$__MYZS__LOGTYPE" == "auto" ]]; then
      datetime="$(date +"%H:%M:%S")"
    fi
    module_key="${__MYZS__CURRENT_MODULE_KEY:-unknown}"

    # make sure that log-file always exist every log event
    local filepath="${MYZS_LOGPATH}"
    if ! test -f "$filepath"; then
      touch "$filepath"
    fi

    printf '%s %-5s [%s]: %s\n' "$datetime" "$logger_level" "$module_key" "$*" >>"$filepath"
  fi

  return 0
}

_myzs:internal:log:debug() {
  _myzs:private:log "DEBUG" "$@"
}

_myzs:internal:log:info() {
  _myzs:private:log "INFO" "$@"
}

_myzs:internal:log:warn() {
  _myzs:private:log "WARN" "$@"
}

_myzs:internal:log:error() {
  _myzs:private:log "ERROR" "$@"
}
