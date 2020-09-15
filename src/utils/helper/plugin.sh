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

# $1 = plugin name
# $2 = plugin version
_myzs:internal:initial-plugin() {
  local plugin_name="$1" plugin_version="$2"

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
    git clone --branch "${plugin_version}" --single-branch "$repo" "$plugin_path" &>>"${logpath}"
  else
    _myzs:internal:log:info "plugin is exist at ${plugin_path}, skip update"
  fi

  plugin_init="${plugin_path}/myzs.init"
  if _myzs:internal:checker:file-exist "${plugin_init}"; then
    _myzs:internal:load "${plugin_name} initial file" "${plugin_init}"
    _myzs:internal:completed
  else
    _myzs:internal:log:error "you loading non myzs plugin module ${plugin_name}"
    _myzs:internal:log:error "immediately deleted repository"
    rm -rf "${plugin_path}"
    _myzs:internal:failed 5
  fi
}

# $1 = plugin name
# $2 = plugin version
_myzs:internal:upgrade-plugin() {
  local oldpath="$PWD" plugin_name="$1" plugin_version="$2"

  local plugin_folder="${__MYZS__PLG}"
  local plugin_path="${plugin_folder}/$plugin_name"

  local repo="git@github.com:$plugin_name.git"

  local logpath="${MYZS_LOGPATH}"
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_folder"; then
    _myzs:internal:failed 1
  else
    _myzs:internal:log:info "upgrading plugin ${plugin_name} version ${plugin_version} at ${plugin_path}"

    cd "${plugin_path}" || exit 1
    git pull origin "${plugin_version}" &>>"${logpath}"

    plugin_init="${plugin_path}/myzs.init"
    _myzs:internal:load "${plugin_name} initial file" "${plugin_init}"

    cd "${oldpath}" || exit 1
  fi
}
