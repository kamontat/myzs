# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

# NOTES: MUST NOT USE $module_path as variable name

# Current, MODULE syntax is csv format
#          module_type,module_name,module_status
#          separate by newline

# convert module key to module name and type
# $1 => input module key
# $2 => function: cmd(module type, module name, module key)
_myzs:internal:module:name-deserialize() {
  local input="$1" cmd="$2"
  shift 2

  local module_type="${input%%\#*}"
  local module_name="${input##*\#}"

  # add prefix if not exist
  ! [[ $module_name =~ \.sh$ ]] && module_name="${module_name}.sh"
  # add module type if not exist
  [[ "$module_type" == "$module_name" ]] && module_type="builtin"

  $cmd "$module_type" "$module_name" "${module_type}#${module_name}" "$@"
}

# convert module name and type to module key
# $1 => module type
# $2 => module name
# return module key string
_myzs:internal:module:name-serialize() {
  local module_type="$1"
  local module_name="$2"

  if _myzs:internal:checker:string-exist "${module_type}" && _myzs:internal:checker:string-exist "${module_name}"; then
    echo "${module_type}#${module_name}"
  elif _myzs:internal:checker:string-exist "${module_name}"; then
    echo "builtin#${module_name}"
  else
    echo "unknown"
  fi
}

_myzs:private:module:index-status() {
  echo "$4" "$3" # index, status
}

_myzs:internal:module:index-status() {
  _myzs:internal:module:search-name "$1" _myzs:private:module:index-status
}

_myzs:private:module:search-name-internal() {
  local _module_type="$1" _module_name="$2" _module_status="$3"
  local _current_index="$4" _total_index="$5"
  local _module_csv="$6"

  local _search_module_type="$7" _search_module_name="$8" _searched_function="$9"

  # echo "$_search_module_type = $_module_type" >&2
  # echo "$_search_module_name = $_module_name" >&2
  if [[ "$_search_module_type" == "$_module_type" ]] && [[ "$_search_module_name" == "$_module_name" ]]; then
    $_searched_function "${_module_type}" "${_module_name}" "${_module_status}" "${_current_index}" "${_total_index}" "${_module_csv}"
  else
    _myzs:internal:completed
  fi
}

_myzs:private:module:search-name() {
  local _search_module_type="$1" _search_module_name="$2" _cmd="$4"

  _myzs:internal:module:loaded-list _myzs:private:module:search-name-internal "${_search_module_type}" "${_search_module_name}" "${_cmd}"
}

# _myzs:internal:module:search-name "builtin#app/index.sh" existing_function
# existing_function "module type" "module name" "module status" "current index" "total index" "module csv"
_myzs:internal:module:search-name() {
  local _input="$1"
  local _cmd="$2"

  _myzs:internal:module:name-deserialize "${_input}" _myzs:private:module:search-name "${_cmd}"
}

_myzs:private:module:search-module-type() {
  local _module_type="$1" _module_name="$2" _module_status="$3"
  local _current_index="$4" _total_index="$5"
  local _module_csv="$6"

  local _search_module_type="$7" _searched_function="$8"

  if [[ "$_search_module_type" == "$_module_type" ]]; then
    $_searched_function "${_module_type}" "${_module_name}" "${_module_status}" "${_current_index}" "${_total_index}" "${_module_csv}"
  else
    _myzs:internal:completed
  fi
}

_myzs:internal:module:search-module-type() {
  local _module_type="$1"
  local _cmd="$2"

  _myzs:internal:module:loaded-list _myzs:private:module:search-module-type "${_module_type}" "${_cmd}"
}

_myzs:private:module:checker:validate() {
  local _module_type="$1" _module_name="$2"
  local _fullpath

  _fullpath="$(_myzs:private:module:fullpath "${_module_type}" "${_module_name}")"
  if _myzs:internal:checker:file-exist "$_fullpath"; then
    _myzs:internal:completed
  else
    _myzs:internal:log:error "cannot found module at $_fullpath"
    _myzs:internal:failed
  fi
}

# validate module name
_myzs:internal:module:checker:validate() {
  local input="$1"
  shift 1
  _myzs:internal:module:name-deserialize "$input" _myzs:private:module:checker:validate
}

_myzs:private:module:fullpath() {
  local _module_type="$1" _module_name="$2"
  local _result_path

  if [[ "$_module_type" == "builtin" ]]; then
    _result_path="${__MYZS__SRC}/${_module_name}"
  elif [[ "$_module_type" == "zplug" ]]; then
    _result_path="${ZPLUG_HOME}/${_module_name}"
  else
    _result_path="${__MYZS__PLG}/${_module_type}/${_module_name}"
  fi

  _myzs:internal:log:info "convert module name $_module_name (type = ${_module_type}) to path $_result_path"

  echo "$_result_path"
}

_myzs:internal:module:fullpath() {
  local _input="$1"
  shift 1
  _myzs:internal:module:name-deserialize "$_input" _myzs:private:module:fullpath
}

_myzs:private:module:saved() {
  local module_type="$1"
  local module_name="$2"
  local module_key="$3"
  local module_status="$4"

  export __MYZS__CURRENT_MODULE_TYPE="${module_type}"
  export __MYZS__CURRENT_MODULE_NAME="${module_name}"
  export __MYZS__CURRENT_MODULE_STATUS="${module_status}"
  export __MYZS__CURRENT_MODULE_KEY="${module_key}"

  __MYZS__MODULES+=("${module_type},${module_name},${module_status}")
}

_myzs:internal:module:query() {
  local cmd="$1" module_type="$2" module_name="$3"
  local module_fullpath

  export __MYZS__CURRENT_MODULE_KEY="$4"

  shift 4
  local args=("$@")

  module_fullpath="$(_myzs:private:module:fullpath "${module_type}" "${module_name}")"
  # shellcheck disable=SC2207
  module_index_status=($(_myzs:internal:module:index-status "$__MYZS__CURRENT_MODULE_KEY"))
  module_index="${module_index_status[1]}"
  module_status="${module_index_status[2]}"

  # validate only when old data is exist
  if test -n "$module_index" && test -n "$module_status"; then
    ((module_index--)) # change array index start from 1 to start from 0

    # skip modules that already passed
    if [[ "$module_status" == "pass" ]]; then
      _myzs:internal:log:debug "skip module '$__MYZS__CURRENT_MODULE_KEY' because this module has been loaded successfully"
      return 255
    fi

    _myzs:internal:log:debug "module = index:'${module_index}' status:'${module_status}' key:'$__MYZS__CURRENT_MODULE_KEY'"
    _myzs:internal:log:debug "module path = ${module_fullpath} '${args[*]}'"

    if [[ "${module_index}" != "" ]] && [[ "${module_index}" != "-1" ]]; then
      _myzs:internal:log:warn "module $__MYZS__CURRENT_MODULE_KEY is existed at #${module_index}; removing"
      _myzs:internal:remove-array-index "__MYZS__MODULES" "${module_index}"
    fi
  fi

  "$cmd" "$__MYZS__CURRENT_MODULE_KEY" "$module_fullpath" "$@"
}

# load module by name
_myzs:private:module:load() {
  local module_type="$1" module_name="$2" module_key="$3" exitcode="0"

  # This allow module to load all existing module in to memory, but it significate increase load time (~42%+)
  # _myzs:internal:plugin:load "$module_type"

  # exitcode 255 meaning module has been loaded, will ignore
  _myzs:internal:module:query _myzs:internal:load "$@"
  exitcode="$?"

  if [[ $exitcode == 0 ]]; then
    _myzs:private:module:saved "$module_type" "$module_name" "$module_key" "pass"
  elif [[ $exitcode != 255 ]]; then
    _myzs:private:module:saved "$module_type" "$module_name" "$module_key" "fail"
  fi
}

# load module by name
_myzs:internal:module:load() {
  local input="$1"
  shift 1
  _myzs:internal:module:name-deserialize "$input" _myzs:private:module:load "$@"
}

# mark module name as skip
_myzs:private:module:skip() {
  _myzs:private:module:saved "$1" "$2" "$3" "skip"
}

# mark module name as skip
_myzs:internal:module:skip() {
  local input="$1"
  shift 1
  _myzs:internal:module:name-deserialize "$input" _myzs:private:module:skip
}

# @deprecated Input callback receive callback(type, name, path)
_myzs:internal:module:total-list() {
  local folder filename dirname __builtin_component __plugin_component
  local plugin plugin_name plugin_path

  local builtin_supported_list=("app" "alias")
  local plugin_supported_list=("app" "alias" "settings" "utils")

  local cmd="$1"

  # TODO: cache all plugins to myzs-plugin tmp
  for folder in "${builtin_supported_list[@]}"; do
    plugin_path="${__MYZS__SRC}/$folder"
    if _myzs:internal:checker:folder-exist "$plugin_path"; then
      for __builtin_component in "${plugin_path}"/*.sh; do
        filename="$(basename "${__builtin_component}")"
        dirname="$(basename "$(dirname "${__builtin_component}")")"

        #cmd $type     $name                $path
        $cmd "builtin" "$dirname/$filename" "$__builtin_component"
      done
    fi
  done

  for folder in "${plugin_supported_list[@]}"; do
    for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
      plugin_name="${plugin%%#*}"
      plugin_path="${__MYZS__PLG}/${plugin_name}/$folder"
      if _myzs:internal:checker:folder-exist "$plugin_path"; then
        for __plugin_component in "$plugin_path"/*.sh; do
          filename="$(basename "${__plugin_component}")"
          dirname="$(basename "$(dirname "${__plugin_component}")")"

          #cmd $type          $name                $path
          $cmd "$plugin_name" "$dirname/$filename" "$__plugin_component"
        done
      fi
    done
  done

  _myzs:internal:completed
}

# @param    $1 cmd "module type" "module name" "module status" "current index" "total index" "module csv"
# @example
#   cmd {
#     local module_type="$1" module_name="$2" module_status="$3"
#     local current_index="$4" total_index="$5"
#     local module_csv="$6"
#   }
_myzs:internal:module:loaded-list() {
  local cmd="$1"
  shift 1
  local args=("$@")

  ! _myzs:internal:checker:command-exist "${cmd}" && echo "Input command ${cmd} is not valid" && _myzs:internal:failed "2"

  local size=0 current=0
  size="${#__MYZS__MODULES[@]}"
  for module_csv in "${__MYZS__MODULES[@]}"; do
    ((current++))
    # shellcheck disable=SC2116
    IFS=',' read -r module_type module_name module_status <<<"$(echo "${module_csv}")"

    if ! $cmd "$module_type" "$module_name" "$module_status" "$current" "$size" "$module_csv" "${args[@]}"; then
      return $?
    fi
  done
}
