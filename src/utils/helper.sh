# shellcheck disable=SC1090,SC2148

export __MYZS_LOGFILE="${MYZS_LOGFILE:-/tmp/myzs.log}"
export MYZS_LOGFILE="$__MYZS_LOGFILE"
export __MYZS_ZPLUG_LOGFILE="${__MYZS_ZPLUG_LOGFILE:-/tmp/zplug.log}"
export MYZS_ZPLUG_LOGFILE="$__MYZS_ZPLUG_LOGFILE"

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

__myzs__log() {
  if [[ "$__MYZS_LOGFILE" != "" ]]; then
    if ! test -f "$__MYZS_LOGFILE"; then
      touch "$__MYZS_LOGFILE"
    fi

    local type datetime

    datetime="$(date)"
    type="$1"
    shift

    echo "$datetime [$type]: $@" >>"$__MYZS_LOGFILE"
  fi

  return 0
}

__myzs__dump_return() {
  return "$1"
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
  local _name="$1" _path="$2" exitcode=1
  if __myzs_is_file_exist "$_path"; then
    source "${_path}"
    exitcode=$?
    if [[ "$exitcode" != "0" ]]; then
      __myzs_error "Cannot load ${_name} (${_path}) because source return $exitcode"
      return 1
    fi

    __myzs_info "Loaded ${_name} (${_path}) to the system"
  else
    __myzs_warn "Cannot load ${_name} (${_path}) because file is missing"
    return 1
  fi
}

# $1 => readable file name
# $2 => file path
export __myzs_load_module
__myzs_load_module() {
  local _name="$1" _path="$2"

  if __myzs_load "$_name" "$_path"; then
    __MYZS_MODULES+=("{1{${_name}}}{2{${_path}}}{3{pass}}")
    __myzs_complete
  else
    __MYZS_MODULES+=("{1{${_name}}}{2{${_path}}}{3{fail}}")
    __myzs_failure 2
  fi
}

export __myzs_skip_module
__myzs_skip_module() {
  local _name="$1" _path="$2"
  __MYZS_MODULES+=("{1{${_name}}}{2{${_path}}}{3{skip}}")
}

export __myzs_alias
__myzs_alias() {
  if __myzs_is_command_exist "$1"; then
    __myzs_warn "Cannot Add $1 alias because [command exist]"
  else
    __myzs_info "Add $1 as alias of $2"
    alias $1=$2
  fi
}

export __myzs_alias_force
__myzs_alias_force() {
  if __myzs_is_command_exist "$1"; then
    __myzs_info "Add $1 as alias of $2 (force)"
    alias $1=$2
  else
    __myzs_alias "$1" "$2"
  fi
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
    if [[ "$PATH" == *"$1"* ]]; then
      __myzs_error "$1 path is already exist to \$PATH"
    else
      __myzs_info "Append $1 to PATH environment"
      export PATH="$1:$PATH"
    fi
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

export __myzs_failure
__myzs_failure() {
  local code="${1:-1}"
  __myzs__dump_return "$code"
}

export __myzs_complete
__myzs_complete() {
  __myzs__dump_return 0
}

export __myzs_is_plugin_installed
__myzs_is_plugin_installed() {
  local name="$1" # full name from plugin
  __myzs_debug "Checking is $name exist in zplug"
  if zplug info "$name" >/dev/null; then
    __myzs_info "$name is installed"
    return 0
  else
    __myzs_warn "package not exist ($name)"
    return 1
  fi
}
