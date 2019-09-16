# shellcheck disable=SC1090,SC2148

export log
log() {
  if [[ "$MYZS_LOG_FILE" != "" ]]; then
    if ! test -f "$MYZS_LOG_FILE"; then
      touch "$MYZS_LOG_FILE"
    fi

    local type
    local timestamp

    timestamp="$(date +%s)"
    type="$1"
    shift

    echo "$timestamp [$type]: $@" >>"$MYZS_LOG_FILE"
  fi

  return 0
}

export log_info
log_info() {
  log "INFO" "$@"
}

export log_warn
log_warn() {
  log "WARN" "$@"
}

export log_error
log_error() {
  log "ERROR" "$@"
}

export is_command_exist
is_command_exist() {
  if command -v "$1" &>/dev/null; then
    log_warn "Checking command $1: EXIST"
    return 0
  else
    log_warn "Checking command $1: MISSING"
    return 1
  fi
}

export is_file_exist
is_file_exist() {
  if test -f "$1"; then
    log_warn "Checking file $1: EXIST"
    return 0
  else
    log_warn "Checking file $1: NOT_FOUND"
    return 1
  fi
}

export is_folder_exist
is_folder_exist() {
  if test -d "$1"; then
    log_warn "Checking folder $1: EXIST"
    return 0
  else
    log_warn "Checking folder $1: NOT_FOUND"
    return 1
  fi
}

export is_string_exist
is_string_exist() {
  if test -n "$1"; then
    log_warn "Checking string '$1': EXIST"
    return 0
  else
    log_warn "Checking string '$1': EMPTY"
    return 1
  fi
}

export get_work_root
get_work_root() {
  log_info "Direct to workspace ${WORK_ROOT}/$1"
  echo "${WORK_ROOT}/$1"
}

export to_work_root
to_work_root() {
  local path
  path="$(get_work_root "$1")"
  if ! is_folder_exist "$path"; then
    log_warn "workspace is not exist; create folder $path"
    mkdir -p "$path"
  fi

  cd "$path" || {
    echo "$path" &&
      return 1
  }
}

# $1 => readable file name
# $2 => file path
export source_file
source_file() {
  if is_file_exist "$2"; then
    source "$2"
    log_warn "Loaded $1 ($2) to the system"
  else
    log_warn "Cannot load $1 ($2) because file is missing" &&
      return 1
  fi
}
