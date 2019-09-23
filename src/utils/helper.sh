# shellcheck disable=SC1090,SC2148

export __MYZS_LOGFILE="${MYZS_LOGFILE:-/tmp/myzs.log}"
export __MYZS_ZPLUG_LOGFILE="${__MYZS_ZPLUG_LOGFILE:-/tmp/zplug.log}"

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export __myzs__log
__myzs__log() {
  if [[ "$__MYZS_LOGFILE" != "" ]]; then
    if ! test -f "$__MYZS_LOGFILE"; then
      touch "$__MYZS_LOGFILE"
    fi

    local type
    local datetime

    datetime="$(date)"
    type="$1"
    shift

    echo "$datetime [$type]: $@" >>"$__MYZS_LOGFILE"
  fi

  return 0
}

export __myzs_debug
__myzs_debug() {
  __myzs__log "DEBUG" "$@"
}

export __myzs_info
__myzs_info() {
  __myzs__log "INFO" "$@"
}

export __myzs_warn
__myzs_warn() {
  __myzs__log "WARN" "$@"
}

export __myzs_error
__myzs_error() {
  __myzs__log "ERROR" "$@"
}

export __myzs_is_command_exist
__myzs_is_command_exist() {
  if command -v "$1" &>/dev/null; then
    __myzs_debug "Checking command $1: EXIST"
    return 0
  else
    __myzs_warn "Checking command $1: MISSING"
    return 1
  fi
}

export __myzs_is_file_exist
__myzs_is_file_exist() {
  if test -f "$1"; then
    __myzs_debug "Checking file $1: EXIST"
    return 0
  else
    __myzs_warn "Checking file $1: NOT_FOUND"
    return 1
  fi
}

export __myzs_is_folder_exist
__myzs_is_folder_exist() {
  if test -d "$1"; then
    __myzs_debug "Checking folder $1: EXIST"
    return 0
  else
    __myzs_warn "Checking folder $1: NOT_FOUND"
    return 1
  fi
}

export __myzs_is_string_exist
__myzs_is_string_exist() {
  if test -n "$1"; then
    __myzs_debug "Checking string '$1': EXIST"
    return 0
  else
    __myzs_warn "Checking string '$1': EMPTY"
    return 1
  fi
}

export __myzs_is_fully
__myzs_is_fully() {
  [[ "${__MYZS_TYPE}" == "FULLY" ]]
}

export __myzs_is_small
__myzs_is_small() {
  [[ "${__MYZS_TYPE}" == "SMALL" ]]
}

# $1 => readable file name
# $2 => file path
export __myzs_load
__myzs_load() {
  local exitcode
  if __myzs_is_file_exist "$2"; then
    source "$2"
    exitcode=$?
    if [[ "$exitcode" != "0" ]]; then
      __myzs_error "Cannot load $1 ($2) because source return $exitcode"
      return 1
    fi

    __myzs_info "Loaded $1 ($2) to the system"
  else
    __myzs_warn "Cannot load $1 ($2) because file is missing"
    return 1
  fi
}

export __myzs_alias
__myzs_alias() {
  __myzs_info "Add $1 as alias of $2"
  alias $1=$2
}

export __myzs_push_path
__myzs_push_path() {
  if __myzs_is_folder_exist "$1"; then
    __myzs_info "Push $1 to PATH environment"
    export PATH="$PATH:$1"
  else
    __myzs_warn "Cannot add $1 to PATH environment because folder is missing"
  fi
}

export __myzs_append_path
__myzs_append_path() {
  if __myzs_is_folder_exist "$1"; then
    __myzs_info "Append $1 to PATH environment"
    export PATH="$1:$PATH"
  else
    __myzs_warn "Cannot add $1 to PATH environment because folder is missing"
  fi
}

export __myzs_fpath
__myzs_fpath() {
  if __myzs_is_folder_exist "$1" || __myzs_is_file_exist "$1"; then
    __myzs_info "Add $1 to fpath environment"
    export fpath+=($1)
  else
    __myzs_warn "Cannot add $1 to fpath environment because folder or file is missing"
  fi
}

export __myzs_manpath
__myzs_manpath() {
  if __myzs_is_folder_exist "$1" || __myzs_is_file_exist "$1"; then
    __myzs_info "Add $1 to MANPATH environment"
    export MANPATH="$MANPATH:$1"
  else
    __myzs_warn "Cannot add $1 to MANPATH environment because folder or file is missing"
  fi
}

export __myzs__dump_return
__myzs__dump_return() {
  return "$1"
}
