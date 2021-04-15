# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

myzs-upload() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2
  local tmp_directory="$PWD"

  cd "$MYZS_ROOT" || exit 1
  echo "Start upload current change to github"
  git status --short
  echo

  ./deploy.sh
  ./deploy-plugins.sh

  cd "${tmp_directory}" || exit 1
}

myzs-download() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  local logpath="${MYZS_LOGPATH}"
  if ! test -f "$logpath"; then
    touch "$logpath"
  fi

  myzs:pg:cleanup
  myzs:pg:start

  cd "$MYZS_ROOT" || exit 1

  myzs:pg:mark "Core" "Fetching update from myzs"
  git fetch >>"${logpath}" || myzs:pg:mark-fail "Cannot fetch data from myzs git"

  myzs:pg:mark "Core" "Pulling update from myzs"
  git pull >>"${logpath}" || myzs:pg:mark-fail "Cannot pull data from myzs git"

  for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
    myzs:pg:mark "Plugin" "Pulling update from $plugin"
    _myzs:internal:plugin:name-deserialize "$plugin" _myzs:internal:plugin:upgrade
  done

  myzs:pg:stop
}

myzs-info() {
  echo "# Introduction

MYZS is a configable zsh initial scripts (known as .zshrc).
This supported modules as shell application or alias scripts and more.

You can upgrade version by run 'myzs-download' to fetch latest version.

## Information

1. Current user:         ${USER}
2. Application location: ${_MYZS_ROOT}
3. Application version:  ${__MYZS__VERSION}
4. Application type:     ${__MYZS_SETTINGS__MYZS_TYPE}
5. Log location:         ${MYZS_LOGPATH}
6. Loading time:         ${PROGRESS_LOADTIME}
7. Loaded time:          ${__MYZS__FINISH_TIME}

## Credit

Created by '$__MYZS__OWNER'
Since      '$__MYZS__SINCE' => '$__MYZS__LAST_UPDATED'
License    '$__MYZS__LICENSE'
"
}

myzs-list-changelogs() {
  local cl="$_MYZS_ROOT/CHANGELOG.md"

  if _myzs:internal:checker:file-exist "$cl"; then
    cat "$cl"
  else
    echo "Cannot found any notes" >&2
    _myzs:internal:failed 2
  fi
}

myzs-list-modules() {
  echo "# Modules"
  echo

  ! _myzs:internal:checker:string-exist "${__MYZS__MODULES[*]}" && echo "Cannot find any modules exist" && exit 2

  printf '| %-3s | %-30s | %-30s | %-6s |\n' "[#]" "[module type]" "[module name]" "[stat]"

  __myzs_list_modules_internal() {
    local module_name="$1"
    local module_fullpath="${2//$MYZS_ROOT/\$MYZS_ROOT}" # replace path with ROOT variable if possible
    local module_status="$3"
    local module_index="$4"

    printf '| %-3s | %-30s | %-30s | %-6s |\n' "${module_index}" "${module_name}" "${module_fullpath}" "${module_status}"
  }

  _myzs:internal:module:loaded-list __myzs_list_modules_internal

  echo
  printf 'Total %s modules\n' "${#__MYZS__MODULES[@]}"
}

# load modules
# param $1 - module name in src only
#       $2 - string as 'debug' to print debug information
myzs-load() {
  _myzs:internal:module:initial "app/myzs.sh#myzs-load"

  local module_type="$1"
  local module_name="$2"
  local module_key
  shift 2
  local args=("$@")

  module_key="$(_myzs:internal:module:name-serialize "${module_type}" "${module_name}")"

  if _myzs:internal:module:checker:validate "$module_key"; then
    if _myzs:internal:module:load "$module_key" "${args[@]}"; then
      _myzs:internal:completed
    else
      _myzs:internal:log:warn "loading module return error"
      _myzs:internal:failed 2
    fi
  else
    _myzs:internal:log:warn "invalid modules ($module_key)"
    _myzs:internal:failed 3
  fi
}

# run myzs load set file: $PWD/.myzs-setup
myzs-setup-local() {
  _myzs:internal:module:initial "app/myzs.sh#myzs-setup-local"

  local fullpath="" current="${1:-$PWD}"
  local filenames=("${MYZS_SETTINGS_SETUP_FILES[@]}")

  for name in "${filenames[@]}"; do
    fullpath="${current}/${name}"
    if _myzs:internal:checker:file-exist "$fullpath"; then
      _myzs:internal:load "local-setup" "$fullpath"
    fi
  done
}

myzs-measure() {
  local cmd="$1"
  shift 1

  myzs:pg:cleanup
  myzs:pg:start

  "$cmd" "$@"

  myzs:pg:stop
}
