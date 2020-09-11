# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

_myzs:private:helper:remove-array-index() {
  eval "$1=( \"\${$1[@]:0:$2}\" \"\${$1[@]:$(($2 + 1))}\" )"
}

_myzs:internal:module:checker:validate() {
  local input="$1"

  ! _myzs:internal:checker:string-exist "${input}" && echo "Cannot found input string" && _myzs:internal:failed "2"
  ! _myzs:internal:checker:string-exist "${__MYZS__FULLY_MODULES[*]}" && echo "Cannot find any modules exist" && _myzs:internal:failed "2"

  if [[ "${__MYZS__FULLY_MODULES[*]}" =~ $input ]]; then
    _myzs:internal:completed
  else
    _myzs:internal:failed
  fi
}

_myzs:internal:module:index() {
  local input="$1"
  local starter_index="${2:-1}"

  ! _myzs:internal:checker:string-exist "${input}" && _myzs:internal:failed "2"
  ! _myzs:internal:checker:string-exist "${__MYZS__MODULES[*]}" && _myzs:internal:failed "2"

  local index
  _myzs:internal:module:index__internal() {
    local module_raw="$6"
    local module_index="$4" # start with 1

    if [[ "$module_raw" =~ $input ]]; then
      index=$((module_index - (starter_index - 1)))
      echo "$index"
      return 1
    fi
  }

  _myzs:internal:module:loop _myzs:internal:module:index__internal

  if _myzs:internal:checker:string-exist "$index"; then
    _myzs:internal:completed
  else
    echo "-1"
    _myzs:internal:failed "3"
  fi
}

_myzs:internal:module:status() {
  local input="$1"

  ! _myzs:internal:checker:string-exist "${input}" && _myzs:internal:failed "2"
  ! _myzs:internal:checker:string-exist "${__MYZS__MODULES[*]}" && _myzs:internal:failed "2"

  local mod reg index result raw raw1

  reg="\{3\{(pass|fail|skip)\}\}"

  index="$(_myzs:internal:module:index "$input")"
  mod="${__MYZS__MODULES[$index]}"
  if [[ $mod =~ $input ]]; then
    raw="$(echo "$mod" | grep -Eoi "${reg}")"
    raw1="${raw//\{3\{/}"
    result="${raw1//\}\}/}"

    echo "$result"
  else
    _myzs:internal:failed "3"
  fi
}

_myzs:internal:module:fullpath() {
  local input="$1"

  ! _myzs:internal:checker:string-exist "${input}" && echo "Cannot found input string" && _myzs:internal:failed "2"

  echo "${_MYZS_ROOT}/${input}"
}

# _myzs:internal:module:load(filename, filepath)
_myzs:internal:module:load() {
  export __MYZS__CURRENT_FILENAME="$1"
  export __MYZS__CURRENT_FILEPATH="$2"
  export __MYZS__CURRENT_STATUS="unknown"

  shift 2
  local args=("$@")
  local index

  index="$(_myzs:internal:module:index "$__MYZS__CURRENT_FILENAME" "0")"
  if [[ "${index}" != "-1" ]]; then
    _myzs:internal:log:info "load exist module $__MYZS__CURRENT_FILENAME at $index"
    _myzs:private:helper:remove-array-index "__MYZS__MODULES" "${index}"
  fi

  if _myzs:internal:load "$__MYZS__CURRENT_FILENAME" "$__MYZS__CURRENT_FILEPATH" "${args[@]}"; then
    __MYZS__CURRENT_STATUS="pass"
    __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
    _myzs:internal:completed
  else
    __MYZS__CURRENT_STATUS="fail"
    __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
    _myzs:internal:failed 2
  fi
}

# _myzs:internal:module:skip(filename, filepath)
_myzs:internal:module:skip() {
  export __MYZS__CURRENT_FILENAME="$1"
  export __MYZS__CURRENT_FILEPATH="$2"
  export __MYZS__CURRENT_STATUS="skip"

  __MYZS__MODULES+=("{1{${__MYZS__CURRENT_FILENAME}}}{2{${__MYZS__CURRENT_FILEPATH}}}{3{$__MYZS__CURRENT_STATUS}}")
}

# _myzs:internal:module:loop = looping all modules and get the information
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
_myzs:internal:module:loop() {
  local cmd="$1"

  ! _myzs:internal:checker:command-exist "${cmd}" && echo "Input command ${cmd} is not valid" && _myzs:internal:failed "2"

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
    # filepath="${filepath//$MYZS_ROOT/\$MYZS_ROOT}"

    raw="$(echo "$mod" | grep -Eoi "${reg3}")"
    raw1="${raw//\{3\{/}"
    filestatus="${raw1//\}\}/}"

    # if command return non-zero exit, break the loop
    if ! $cmd "$filename" "$filepath" "$filestatus" "$current" "$size" "$mod"; then
      return $?
    fi
  done
}
