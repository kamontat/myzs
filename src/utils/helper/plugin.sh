# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

# convert plugin key to plugin name and version
# $1 => input plugin key
# $2 => function: cmd(plugin name, plugin version)
_myzs:internal:plugin:name-deserialize() {
  local input="$1" cmd="$2"
  local plugin_name="${input%%#*}"
  local plugin_version="${input##*#}"

  shift 2

  [[ "$plugin_name" == "$plugin_version" ]] && plugin_version="master"

  $cmd "$plugin_name" "$plugin_version" "$@"
}

# convert plugin name and version to plugin key
# $1 => plugin name
# $2 => plugin version
# return plugin key string
_myzs:internal:plugin:name-serialize() {
  local plugin_name="$1"
  local plugin_version="$2"

  if _myzs:internal:checker:string-exist "${plugin_name}" && _myzs:internal:checker:string-exist "${plugin_version}"; then
    echo "${plugin_name}#${plugin_version}"
  elif _myzs:internal:checker:string-exist "${plugin_name}"; then
    echo "${plugin_name}#master"
  else
    echo "unknown"
    _myzs:internal:failed 3
  fi
}

# _myzs:private:plugin:saved $start_time (download|upgrade) $name $version (pass|fail|skip) (pass|fail)
_myzs:private:plugin:saved() {
  local plugin_start_time="$1"
  local plugin_action="$2"
  local plugin_name="$3"
  local plugin_version="$4"
  local plugin_step1_status="$5" # cloning repository step
  local plugin_step2_status="$6" # initial myzs.init file step

  local plugin_finish_time plugin_load_time
  plugin_finish_time="$(_myzs:internal:timestamp-millisecond)"

  export __MYZS__CURRENT_PLUGIN_KEY
  __MYZS__CURRENT_PLUGIN_KEY="$(_myzs:internal:plugin:name-serialize "${__MYZS__CURRENT_PLUGIN_TYPE}" "${__MYZS__CURRENT_PLUGIN_NAME}")"

  plugin_load_time="$((plugin_finish_time - plugin_start_time))"

  __MYZS__PLUGINS+=(
    "${plugin_action},${plugin_name},${plugin_version},${plugin_step1_status},${plugin_step2_status},${plugin_load_time}"
  )
}

# $1 = plugin name
# $2 = plugin version
_myzs:internal:plugin:load() {
  local plugin_name="$1" plugin_version="$2"
  local plugin_start_time plugin_action="download" plugin_status1="pass"
  plugin_start_time="$(_myzs:internal:timestamp-millisecond)"

  local plugin_folder="${__MYZS__PLG}"
  local plugin_path="${plugin_folder}/$plugin_name"

  local repo="git@github.com:$plugin_name.git"

  local logpath="${MYZS_LOGPATH}"
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_folder"; then
    mkdir "$plugin_folder"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_path"; then
    _myzs:internal:log:info "clone new plugin to ${plugin_path}"
    _myzs:internal:log:debug "git clone --branch '${plugin_version}' --single-branch '$repo' '$plugin_path'"

    if ! git clone --branch "${plugin_version}" --single-branch "$repo" "$plugin_path" >>"${logpath}" 2>&1; then
      plugin_status1="fail"
    fi
  else
    _myzs:internal:log:info "plugin is exist at ${plugin_path}, skip update"
    plugin_status1="skip"
  fi

  if [[ "$plugin_status1" != "fail" ]]; then
    plugin_init="${plugin_path}/myzs.init"
    if _myzs:internal:checker:file-exist "$plugin_init"; then
      _myzs:internal:completed

      # TODO: internal load take around 50ms, improve it before uncomment below code
      # if _myzs:internal:load "${plugin_name} initial file" "${plugin_init}"; then
      #   _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "$plugin_status1" "pass"
      #   _myzs:internal:completed
      # else
      #   _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "$plugin_status1" "fail"
      #   _myzs:internal:log:error "Cannot initial myzs.init file"
      #   _myzs:internal:completed
      # fi
    else
      _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "$plugin_status1" "fail"
      _myzs:internal:log:error "MYZS plugin must have myzs.init file on root (${plugin_name})"
      rm -rf "${plugin_path}"
      _myzs:internal:failed 5
    fi
  else
    _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "$plugin_status1" "$plugin_status1"
    _myzs:internal:log:error "cloning repository failed"
    rm -rf "${plugin_path}" >/dev/null
    _myzs:internal:failed 5
  fi
}

# $1 = plugin name
# $2 = plugin version
_myzs:internal:plugin:upgrade() {
  local oldpath="$PWD" plugin_name="$1" plugin_version="$2"
  local plugin_start_time plugin_action="upgrade" plugin_status1="pass" plugin_status2="pass"
  plugin_start_time="$(_myzs:internal:timestamp-millisecond)"

  local plugin_folder="${__MYZS__PLG}"
  local plugin_path="${plugin_folder}/$plugin_name"

  local repo="git@github.com:$plugin_name.git"

  local logpath="${MYZS_LOGPATH}"
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_folder"; then
    _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "fail" "fail"
    _myzs:internal:failed 1
  else
    _myzs:internal:log:info "upgrading plugin ${plugin_name} version ${plugin_version} at ${plugin_path}"

    cd "${plugin_path}" || exit 1

    if ! git pull origin "${plugin_version}" >>"${logpath}" 2>&1; then
      plugin_status1="fail"
    fi

    plugin_init="${plugin_path}/myzs.init"
    if ! _myzs:internal:load "${plugin_name} initial file" "${plugin_init}"; then
      plugin_status2="fail"
    fi

    _myzs:internal:metric:log-plugin "$plugin_start_time" "$plugin_action" "$plugin_name" "$plugin_version" "$plugin_status1" "$plugin_status2"
    cd "${oldpath}" || exit 1
  fi
}
