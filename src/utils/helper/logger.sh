# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

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

  if echo "${MYZS_LOG_LEVEL[*]}" | grep -iqF "$logger_level"; then
    if [[ "$__MYZS__LOGDIR" != "" ]] && [[ $__MYZS__LOGFILE != "" ]]; then
      if ! test -d "$__MYZS__LOGDIR"; then
        mkdir -p "$__MYZS__LOGDIR" >/dev/null
      fi

      local filepath="${MYZS_LOGPATH}"
      if ! test -f "$filepath"; then
        touch "$filepath"
      fi

      local datetime module_key

      datetime="$(date)"
      if [[ "$__MYZS__LOGTYPE" == "auto" ]]; then
        datetime="$(date +"%H:%M:%S")"
      fi
      module_key="${__MYZS__CURRENT_MODULE_KEY:-unknown}"

      printf '%s %-5s [%s]: %s\n' "$datetime" "$logger_level" "$module_key" "$*" >>"$filepath"
    fi
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

_myzs:internal:log:set-level() {
  _myzs:internal:log:info "update log level to $*"

  export MYZS_PREVIOUS_LOG_LEVEL=("${MYZS_LOG_LEVEL[@]}")

  unset MYZS_LOG_LEVEL
  export MYZS_LOG_LEVEL=("$@")
}

_myzs:log:silent() {
  _myzs:internal:log:info "update log level to silent mode"

  export MYZS_PREVIOUS_LOG_LEVEL=("${MYZS_LOG_LEVEL[@]}")

  unset MYZS_LOG_LEVEL
  export MYZS_LOG_LEVEL=()
}

_myzs:log:debug() {
  _myzs:internal:log:set-level "error" "warn" "info" "debug"
}

_myzs:log:info() {
  _myzs:internal:log:set-level "error" "warn" "info"
}

_myzs:log:warn() {
  _myzs:internal:log:set-level "error" "warn"
}

_myzs:log:error() {
  _myzs:internal:log:set-level "error"
}

_myzs:log:revert() {
  _myzs:internal:log:set-level "${MYZS_PREVIOUS_LOG_LEVEL[@]}"
}
