# shellcheck disable=SC1091,SC2148

myzs:module:new "$0"

# myzs deploy [(all|app|plugin)] - deploy base on input (default is only app)
_myzs:internal:app:deploy() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  local upload_type="${1:-app}" previous_directory="$PWD"
  cd "$MYZS_ROOT" || exit 1

  echo "Start upload current change to github"
  git status --short
  echo

  if [[ "$upload_type" == "all" ]] || [[ "$upload_type" == "app" ]]; then
    source "./deploy.sh"
  fi

  if [[ "$upload_type" == "all" ]] || [[ "$upload_type" == "plugin" ]]; then
    source "./deploy-plugins.sh"
  fi

  cd "$previous_directory" || exit 1
}

# myzs upgrade [(all|app|plugin)] - upgrade base on input (default is all: both app and plugin)
_myzs:internal:app:upgrade() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  local upgrade_type="${1:-all}" previous_directory="$PWD" logpath="${MYZS_LOGPATH}"

  # ensure logpath is exist
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  cd "$MYZS_ROOT" || exit 1
  myzs:pg:cleanup
  myzs:pg:start

  if [[ "$upgrade_type" == "all" ]] || [[ "$upgrade_type" == "app" ]]; then
    myzs:pg:step "Core" "Fetching update from myzs"
    git fetch >>"${logpath}" || myzs:pg:mark-fail "Core" "Cannot fetch data from myzs git"

    myzs:pg:step "Core" "Pulling update from myzs"
    git pull >>"${logpath}" || myzs:pg:mark-fail "Core" "Cannot pull data from myzs git"
  fi

  if [[ "$upgrade_type" == "all" ]] || [[ "$upgrade_type" == "plugin" ]]; then
    for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
      myzs:pg:step "Plugin" "Pulling update from $plugin"
      _myzs:internal:plugin:name-deserialize "$plugin" _myzs:internal:plugin:upgrade
    done
  fi

  myzs:pg:stop
  cd "$previous_directory" || exit 1
}

# myzs load <plugin_name> <module_name>
_myzs:internal:app:load() {
  myzs:module:new "app/myzs.sh#myzs-install"

  local module_type="$1"
  local module_name="$2"
  local module_key
  shift 2
  local args=("$@")

  module_key="$(_myzs:internal:module:name-serialize "${module_type}" "${module_name}")"

  if _myzs:internal:module:checker:validate "$module_key"; then
    if _myzs:internal:module:load "$module_key" "${args[@]}"; then
      return 0
    else
      _myzs:internal:log:warn "loading module return error"
      return 2
    fi
  else
    _myzs:internal:log:warn "invalid modules ($module_key)"
    return 3
  fi
}

# myzs info
_myzs:internal:app:info() {
  local app_type
  app_type="$(_myzs:internal:db:getter:string "setting" "type")"

  echo "# Introduction

MYZS is a configable zsh initial scripts (known as .zshrc).
This supported modules as shell application or alias scripts and more.

You can upgrade version by run 'myzs upgrade' to fetch latest version.

## Information

1. Current user:         ${USER}
2. Application location: ${_MYZS_ROOT}
3. Application version:  v${__MYZS__VERSION}
4. Application type:     ${app_type}
5. Log location:         ${MYZS_LOGPATH}
6. Loading time:         ${STARTUP_LOADTIME}
7. Loaded time:          ${__MYZS__FINISH_TIME}

## Credit

Created by '$__MYZS__OWNER'
Since      '$__MYZS__SINCE' => '$__MYZS__LAST_UPDATED'
License    '$__MYZS__LICENSE'
"
}

# myzs changelogs
_myzs:internal:app:changelogs() {
  local cl="$_MYZS_ROOT/docs/CHANGELOG.md"

  if _myzs:internal:checker:file-exist "$cl"; then
    cat "$cl"
  else
    echo "Cannot found any notes" >&2
    return 2
  fi
}

# myzs modules
_myzs:internal:app:modules() {
  echo "# Modules"
  echo

  ! _myzs:internal:checker:string-exist "${__MYZS__MODULES[*]}" && echo "Cannot find any modules exist" && exit 2

  printf '| %-3s | %-26s | %-22s | %-6s |\n' "[#]" "[module type]" "[module name]" "[stat]"

  __myzs_list_modules_internal() {
    local module_name="$1"
    local module_fullpath="${2//$MYZS_ROOT/\$MYZS_ROOT}" # replace path with ROOT variable if possible
    local module_status="$3"
    local module_index="$4"

    printf '| %-3s | %-26s | %-22s | %-6s |\n' "${module_index}" "${module_name}" "${module_fullpath}" "${module_status}"
  }

  _myzs:internal:module:loaded-list __myzs_list_modules_internal

  echo
  printf 'Total %s modules\n' "${#__MYZS__MODULES[@]}"
}

# myzs loads <group_name>
_myzs:internal:app:loads() {
  _myzs:internal:group:load "$1"
}

myzs() {
  local cmd_type="$1" cmd_name
  shift

  cmd_name="_myzs:internal:app:$cmd_type"
  if command -v "$cmd_name" >/dev/null; then
    "$cmd_name" "$@"
  else
    _myzs:internal:log:error "we cannot found $cmd_name command"
    return 1
  fi
}

# run myzs load set file: $PWD/.myzs-setup
myzs-setup-local() {
  echo "!! This setup local is deprecated. Please use group feature instead !!" >&2

  myzs:module:new "app/myzs.sh#myzs-setup-local"

  local fullpath="" current="${1:-$PWD}"
  local filenames=()
  myzs:setting:get-array "setup-file/list" filenames

  for name in "${filenames[@]}"; do
    fullpath="${current}/${name}"
    if _myzs:internal:checker:file-exist "$fullpath"; then
      _myzs:internal:load "local-setup" "$fullpath"
    fi
  done
}
