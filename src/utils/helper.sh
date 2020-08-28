# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export __MYZS_LOGTYPE="${MYZS_LOGTYPE:-auto}"
export __MYZS_LOGDIR="${MYZS_LOGDIR:-/tmp/myzs/logs}"
export __MYZS_DATADIR="${MYZS_DATADIR:-/tmp/myzs/data}"
export __MYZS_LOGFILE="${MYZS_LOGFILE:-main.log}"
export __MYZS__ZPLUG_LOGFILE="${MYZS_ZPLUG_LOGFILE:-zplug.log}"

if [[ "$__MYZS_LOGTYPE" == "auto" ]]; then
  __MYZS_LOGFILE="main-$(date +"%y%m%d").log"
  __MYZS__ZPLUG_LOGFILE="zplug-$(date +"%y%m%d").log"
fi

export MYZS_LOGPATH="${__MYZS_LOGDIR}/${__MYZS_LOGFILE}"
export MYZS_ZPLUG_LOGPATH="${__MYZS_LOGDIR}/${__MYZS__ZPLUG_LOGFILE}"

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
    if [[ "$__MYZS_LOGTYPE" == "auto" ]]; then
      datetime="$(date +"%H:%M:%S")"
    fi
    filename="${__MYZS__CURRENT_FILENAME:-unknown}"

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
    export __MYZS__CURRENT_FILENAME="$filename"
  else
    export __MYZS__CURRENT_FILENAME="${__MYZS__CURRENT_FILENAME:-$filename}"
  fi

  __myzs_info "start new modules"
}

export __myzs_cleanup
__myzs_cleanup() {
  __myzs_info "cleanup application"
  unset __MYZS__CURRENT_FILENAME __MYZS__CURRENT_FILEPATH __MYZS__CURRENT_STATUS

  unset MYZS_SETTINGS_WELCOME_MESSAGE MYZS_START_COMMAND MYZS_START_COMMAND_ARGUMENTS

  # for e in $(env | grep MYZS); do
  #   echo "e: $e"
  # done
}

export __myzs_metric
__myzs_metric() {
  local data_file="${MYZS_METRICPATH}"
  if ! __myzs_is_file_exist "$data_file"; then
    echo "date time,passed modules,failed modules,skipped modules,unknown modules,total modules,load time" >"$data_file"
  fi

  local passed=0 failed=0 skipped=0 unknown=0 total=0

  __myzs_metric_module_counter_internal() {
    local module_status="$3"
    total="$5"
    if [[ "$module_status" == "pass" ]]; then
      passed=$((passed + 1))
    elif [[ "$module_status" == "fail" ]]; then
      failed=$((failed + 1))
    elif [[ "$module_status" == "skip" ]]; then
      skipped=$((skipped + 1))
    else
      unknown=$((unknown + 1))
    fi
  }

  __myzs_loop_modules __myzs_metric_module_counter_internal

  echo "${__MYZS__FINISH_TIME},${passed},${failed},${skipped},${unknown},${total},${PROGRESS_LOADTIME_MS}" >>"$data_file"
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
    __myzs_debug "Checking string '${1:0:10}': EXIST"
    return 0
  else
    __myzs_warn "Checking string '$1': EMPTY"
    return 1
  fi
}

export __myzs_is_fully
__myzs_is_fully() {
  [[ "${__MYZS__TYPE}" == "FULLY" ]]
}

export __myzs_is_small
__myzs_is_small() {
  [[ "${__MYZS__TYPE}" == "SMALL" ]]
}

export __myzs_shell_is_bash
__myzs_shell_is_bash() {
  __myzs__shell_is "bash"
}

export __myzs_shell_is_zsh
__myzs_shell_is_zsh() {
  __myzs__shell_is "zsh"
}

export __myzs_is_mac
__myzs_is_mac() {
  local name
  name="$(uname -s)"
  if [[ "$name" = "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}

export __myzs__remove_array_index
__myzs__remove_array_index() {
  eval "$1=( \"\${$1[@]:0:$2}\" \"\${$1[@]:$(($2 + 1))}\" )"
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
      __myzs_failure
    fi

    __myzs_info "Loaded ${_name} (${_path}) to the system"
    __myzs_complete
  else
    __myzs_warn "Cannot load ${_name} (${_path}) because file is missing"
    __myzs_failure
  fi
}

# $1 => readable file name
# $2 => file path
export __myzs_load_module
__myzs_load_module() {
  export __MYZS__CURRENT_FILENAME="$1"
  export __MYZS__CURRENT_FILEPATH="$2"
  export __MYZS__CURRENT_STATUS="unknown"

  local index

  index="$(__myzs__get_module_index "$__MYZS__CURRENT_FILENAME" "0")"
  if [[ "${index}" != "-1" ]]; then
    __myzs_info "load exist module $__MYZS__CURRENT_FILENAME at $index"
    __myzs__remove_array_index "__MYZS__MODULES" "${index}"
  fi

  if __myzs_load "$__MYZS__CURRENT_FILENAME" "$__MYZS__CURRENT_FILEPATH"; then
    __MYZS__CURRENT_STATUS="pass"
    __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
    __myzs_complete
  else
    __MYZS__CURRENT_STATUS="fail"
    __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
    __myzs_failure 2
  fi
}

export __myzs_skip_module
__myzs_skip_module() {
  export __MYZS__CURRENT_FILENAME="$1"
  export __MYZS__CURRENT_FILEPATH="$2"
  export __MYZS__CURRENT_STATUS="skip"

  __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
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

# __myzs_loop_modules = looping all modules and get the information
#     @param 1 (cmd)  = the bash function accept 6 parameters
#                     = cmd "$module_name" "$module_path" "$module_status" "$module_index" "$total_module" "$module_raw"
#     @example
#                       cmd() {
#                           local module_name="$1"
#                           local module_path="$2"
#                           local module_status="$3"
#                           local module_index="$4"
#                           local total_module="$5"
#                           local module_raw="$6"
#                       }
export __myzs_loop_modules
__myzs_loop_modules() {
  local cmd="$1"

  ! __myzs_is_command_exist "${cmd}" && echo "Input command ${cmd} is not valid" && __myzs_failure "2"

  local mod reg1 reg2 reg3 filename filepath filestatus raw raw1

  reg1="\{1\{([^\{\}]+)\}\}"
  reg2="\{2\{([^\{\}]+)\}\}"
  reg3="\{3\{(pass|fail|skip)\}\}"

  local size=0 current=0

  size="${#__MYZS__MODULES[@]}"
  for mod in "${__MYZS__MODULES[@]}"; do
    ((current++))
    raw="$(echo "$mod" | grep -Eoi "${reg1}")"
    raw1="${raw//\{1\{/}"
    filename="${raw1//\}\}/}"

    raw="$(echo "$mod" | grep -Eo "${reg2}")"
    raw1="${raw//\{2\{/}"
    filepath="${raw1//\}\}/}"
    filepath="${filepath//$MYZS_ROOT/\$MYZS_ROOT}"

    raw="$(echo "$mod" | grep -Eoi "${reg3}")"
    raw1="${raw//\{3\{/}"
    filestatus="${raw1//\}\}/}"

    # if command return non-zero exit, break the loop
    if ! $cmd "$filename" "$filepath" "$filestatus" "$current" "$size" "$mod"; then
      return $?
    fi
  done
}

export __myzs__is_valid_module
__myzs__is_valid_module() {
  local input="$1"

  ! __myzs_is_string_exist "${input}" && echo "Cannot found input string" && __myzs_failure "2"
  ! __myzs_is_string_exist "${__MYZS__FULLY_MODULES[*]}" && echo "Cannot find any modules exist" && __myzs_failure "2"

  if [[ "${__MYZS__FULLY_MODULES[*]}" =~ $input ]]; then
    __myzs_complete
  else
    __myzs_failure
  fi
}

export __myzs__get_module_index
__myzs__get_module_index() {
  local input="$1"
  local starter_index="${2:-1}"

  ! __myzs_is_string_exist "${input}" && __myzs_failure "2"
  ! __myzs_is_string_exist "${__MYZS__MODULES[*]}" && __myzs_failure "2"

  local index
  __myzs__get_module_index__internal() {
    local module_raw="$6"
    local module_index="$4" # start with 1

    if [[ "$module_raw" =~ $input ]]; then
      index=$((module_index - (starter_index - 1)))
      echo "$index"
      return 1
    fi
  }

  __myzs_loop_modules __myzs__get_module_index__internal

  if __myzs_is_string_exist "$index"; then
    __myzs_complete
  else
    echo "-1"
    __myzs_failure "3"
  fi
}

export __myzs__get_module_status
__myzs__get_module_status() {
  local input="$1"

  ! __myzs_is_string_exist "${input}" && __myzs_failure "2"
  ! __myzs_is_string_exist "${__MYZS__MODULES[*]}" && __myzs_failure "2"

  local mod reg index result raw raw1

  reg="\{3\{(pass|fail|skip)\}\}"

  index="$(__myzs__get_module_index "$input")"
  mod="${__MYZS__MODULES[$index]}"
  if [[ $mod =~ $input ]]; then
    raw="$(echo "$mod" | grep -Eoi "${reg}")"
    raw1="${raw//\{3\{/}"
    result="${raw1//\}\}/}"

    echo "$result"
  else
    __myzs_failure "3"
  fi
}

# update cache directory if not exist
if __myzs_is_string_exist "$__MYZS_DATADIR" && ! __myzs_is_folder_exist "$__MYZS_DATADIR"; then
  mkdir "$__MYZS_DATADIR"
fi

export MYZS_METRICPATH="$__MYZS_DATADIR/metric.csv"
