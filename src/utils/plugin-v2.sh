# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

export __MYZS__PLUGIN_KEY="plugin"

# convert plugin key to plugin name and version
# $1 => input plugin key
# $2 => function: cmd(plugin name, plugin version)
_myzs:internal:plugin:name-deserialize() {
  local input="$1" cmd="$2"
  local plugin_name="${input%%#*}"
  local plugin_version="${input##*#}"

  shift 2

  [[ "$plugin_name" == "$plugin_version" ]] && plugin_version="main"
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
    echo "${plugin_name}#main"
  else
    echo "unknown"
    _myzs:internal:failed 3
  fi
}

# show whether plugin is loaded and completed
_myzs:private:plugin:is-done() {
  local plugin_name="$1" plugin_version="$2"
  _myzs:internal:db:checker:string "$__MYZS__PLUGIN_KEY" "$plugin_name-status" "pass" "skip"
}

# _myzs:private:plugin:saved $name $version (pass|fail|skip|unknown)
_myzs:private:plugin:saved() {
  local plugin_name="$1" plugin_version="$2" plugin_status="${3:-unknown}"

  _myzs:internal:db:setter:string "$__MYZS__PLUGIN_KEY" "$plugin_name" "$plugin_version"
  _myzs:internal:db:setter:string "$__MYZS__PLUGIN_KEY" "$plugin_name-status" "$plugin_status"
  _myzs:internal:db:append:array "$__MYZS__PLUGIN_KEY" "plugins" "$plugin_name"
}

# TODO: add support metrics when we load plugins
_myzs:internal:plugin:install() {
  local plugin_name="$1" plugin_version="$2" plugin_status="pass"
  local plugin_path="${__MYZS__PLG}/$plugin_name"
  local plugin_repo="git@github.com:$plugin_name.git" # TODO: change this to configable data, default git clone using ssh

  # skip install when it initial on current terminal session
  if _myzs:private:plugin:is-done "$plugin_name" "$plugin_version"; then
    return 0
  fi

  # clone repository if not exist
  if ! _myzs:internal:checker:folder-exist "$plugin_path"; then
    _myzs:internal:log:info "clone new plugin to ${plugin_path}"

    _myzs:internal:log:debug "$ git clone --branch '$plugin_version' --single-branch '$plugin_repo' '$plugin_path'"
    if ! git clone --branch "${plugin_version}" --single-branch "$plugin_repo" "$plugin_path" >>"$MYZS_LOGPATH" 2>&1; then
      _myzs:internal:log:error "cloning repository failed"
      _myzs:private:plugin:saved "$plugin_name" "$plugin_version" "fail"
      return 6 # fail by git command
    fi
  else
    _myzs:internal:log:info "plugin is exist at $plugin_path, skip update"
    plugin_status="skip"
  fi

  # validate myzs.init file
  plugin_init="${plugin_path}/myzs.init"
  if ! _myzs:internal:checker:file-exist "$plugin_init"; then
    _myzs:internal:log:error "plugin must have myzs.init file on root ($plugin_name)"
    _myzs:private:plugin:saved "$plugin_name" "$plugin_version" "fail"

    rm -rf "$plugin_path" >/dev/null # delete plugin_path
    return 5                         # fail by validation fails
  fi

  _myzs:private:plugin:saved "$plugin_name" "$plugin_version" "$plugin_status"
}

# TODO: add upgrade history to database apis
_myzs:internal:plugin:upgrade() {
  local plugin_name="$1" plugin_version="$2"
  local plugin_path="${__MYZS__PLG}/$plugin_name"
  if ! _myzs:internal:checker:folder-exist "$plugin_path"; then
    _myzs:internal:log:error "cannot upgrade non-exist plugin name '$plugin_name'"
    return 5
  fi

  # execute pull latest changes from $plugin_path path
  if ! git pull -C "$plugin_path" origin "$plugin_version" >>"$MYZS_LOGPATH" 2>&1; then
    _myzs:internal:log:error "cannot pulling latest from plugin name '$plugin_name'"
    return 6
  fi

  # validate myzs.init file
  plugin_init="${plugin_path}/myzs.init"
  if ! _myzs:internal:checker:file-exist "$plugin_init"; then
    _myzs:internal:log:error "plugin must have myzs.init file on root ($plugin_name)"
    _myzs:private:plugin:saved "$plugin_name" "$plugin_version" "fail"

    rm -rf "$plugin_path" >/dev/null # delete plugin_path
    return 5                         # fail by validation fails
  fi

  # finish upgrading plugin repository
  return 0
}

_myzs:internal:plugin:initial() {
  local plugin="$1"
  _myzs:internal:plugin:name-deserialize "$plugin" _myzs:internal:plugin:install
}
