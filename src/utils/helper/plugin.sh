# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

_myzs:private:load-plugin() {
  local name="$1"

  local plugin_folder="${__MYZS__PGL}"
  local plugin_path="${plugin_folder}/$name"

  local repo="git@github.com:$name.git"

  local logpath="${MYZS_LOGPATH}"
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_folder"; then
    mkdir "$plugin_folder"
  fi

  if ! _myzs:internal:checker:folder-exist "$plugin_path"; then
    _myzs:internal:log:info "clone new plugin to ${plugin_path}"
    git clone "$repo" "$plugin_path" &>>"${logpath}"
  else
    _myzs:internal:log:info "plugin is exist at ${plugin_path}, skip update"
  fi
}

_myzs:internal:initial-plugins() {
  for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
    _myzs:private:load-plugin "$plugin"
  done
}
