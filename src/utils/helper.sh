# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export __MYZS_LOGDIR="${MYZS_LOGDIR:-/tmp/myzs/logs}"
export __MYZS_LOGFILE="${MYZS_LOGFILE:-main.log}"
export __MYZS_ZPLUG_LOGFILE="${MYZS_ZPLUG_LOGFILE:-zplug.log}"

export MYZS_LOGPATH="${__MYZS_LOGDIR}/${__MYZS_LOGFILE}"
export MYZS_ZPLUG_LOGPATH="${__MYZS_LOGDIR}/${__MYZS_ZPLUG_LOGFILE}"

__myzs__log() {
  if [[ "$__MYZS_LOGDIR" != "" ]] && [[ $__MYZS_LOGFILE != "" ]]; then
    if ! test -d "$__MYZS_LOGDIR"; then
      mkdir -p "$__MYZS_LOGDIR" >/dev/null
    fi

    local filepath="${MYZS_LOGPATH}"
    if ! test -f "$filepath"; then
      touch "$filepath"
    fi

    local type datetime filename

    datetime="$(date)"
    filename="${CURRENT_FILENAME:-unknown}"

    type="$1"
    shift

    echo "$datetime [$type] [$filename]: $*" >>"$filepath"
  fi

  return 0
}

__myzs__dump_return() {
  return "$1"
}

__myzs__shell_is() {
  if [[ "$SHELL" =~ $1 ]]; then
    return 0
  else
    return 1
  fi
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

export __myzs_initial
__myzs_initial() {
  if [[ "$MYZS_DEBUG" == "true" ]]; then
    set -x # enable DEBUG MODE
  fi

  local filename
  filename="$(basename "$1")"
  if [[ "$2" == "force" ]]; then
    export CURRENT_FILENAME="$filename"
  else
    export CURRENT_FILENAME="${CURRENT_FILENAME:-$filename}"
  fi

  __myzs_info "start new modules"
}

export __myzs_cleanup
__myzs_cleanup() {
  __myzs_info "cleanup application"
  unset CURRENT_FILENAME CURRENT_FILEPATH CURRENT_STATUS
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

export __myzs_is_file_contains
__myzs_is_file_contains() {
  local filename="$1" searching="$2"
  if grep "$searching" "$filename" >/dev/null; then
    __myzs_debug "Found $searching in $filename file content"
    return 0
  else
    __myzs_debug "Cannot found $searching in $filename file content"
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

export __myzs_shell_is_bash
__myzs_shell_is_bash() {
  __myzs__shell_is "bash"
}

export __myzs_shell_is_zsh
__myzs_shell_is_zsh() {
  __myzs__shell_is "zsh"
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
  export CURRENT_FILENAME="$1"
  export CURRENT_FILEPATH="$2"
  export CURRENT_STATUS="unknown"

  if __myzs_load "$CURRENT_FILENAME" "$CURRENT_FILEPATH"; then
    CURRENT_STATUS="pass"
    __MYZS_MODULES+=("{1{${CURRENT_FILENAME}}}{2{${CURRENT_FILEPATH}}}{3{$CURRENT_STATUS}}")
    __myzs_complete
  else
    CURRENT_STATUS="fail"
    __MYZS_MODULES+=("{1{${CURRENT_FILENAME}}}{2{${CURRENT_FILEPATH}}}{3{$CURRENT_STATUS}}")
    __myzs_failure 2
  fi
}

export __myzs_skip_module
__myzs_skip_module() {
  export CURRENT_FILENAME="$1"
  export CURRENT_FILEPATH="$2"
  export CURRENT_STATUS="skip"

  __MYZS_MODULES+=("{1{${CURRENT_FILENAME}}}{2{${CURRENT_FILEPATH}}}{3{$CURRENT_STATUS}}")
}

export __myzs_alias
__myzs_alias() {
  if __myzs_is_command_exist "$1"; then
    __myzs_warn "Cannot Add $1 alias because [command exist]"
  else
    __myzs_info "Add $1 as alias of $2"
    # shellcheck disable=SC2139
    alias "$1"="$2"
  fi
}

export __myzs_alias_force
__myzs_alias_force() {
  if __myzs_is_command_exist "$1"; then
    __myzs_info "Add $1 as alias of $2 (force)"
    # shellcheck disable=SC2139
    alias "$1"="$2"
  else
    __myzs_alias "$1" "$2"
  fi
}

export __myzs_push_path
__myzs_push_path() {
  for i in "$@"; do
    if __myzs_is_folder_exist "$i"; then
      if [[ "$PATH" == *"$i"* ]]; then
        __myzs_error "$i path is already exist to \$PATH"
      else
        __myzs_info "Push $i to PATH environment"
        export PATH="$PATH:$i"
      fi
    else
      __myzs_warn "Cannot add $i to PATH environment because folder is missing"
    fi
  done
}

export __myzs_append_path
__myzs_append_path() {
  for i in "$@"; do
    if __myzs_is_folder_exist "$i"; then
      if [[ "$PATH" == *"$i"* ]]; then
        __myzs_error "$i path is already exist to \$PATH"
      else
        __myzs_info "Append $i to PATH environment"
        export PATH="$i:$PATH"
      fi
    else
      __myzs_warn "Cannot add $i to PATH environment because folder is missing"
    fi
  done
}

export __myzs_fpath
__myzs_fpath() {
  for i in "$@"; do
    if __myzs_is_folder_exist "$i" || __myzs_is_file_exist "$i"; then
      __myzs_info "Add $i to fpath environment"
      export fpath+=("$i")
    else
      __myzs_warn "Cannot add $i to fpath environment because folder or file is missing"
    fi
  done
}

export __myzs_manpath
__myzs_manpath() {
  for i in "$@"; do
    if __myzs_is_folder_exist "$i" || __myzs_is_file_exist "$i"; then
      __myzs_info "Add $i to MANPATH environment"
      export MANPATH="$MANPATH:$i"
    else
      __myzs_warn "Cannot add $i to MANPATH environment because folder or file is missing"
    fi
  done
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
