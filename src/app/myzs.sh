# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

myzs-upload() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  cd "$MYZS_ROOT" || exit 1
  echo "Start upload current change to github"
  git status --short
  echo

  ./deploy.sh
}

myzs-download() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  cd "$MYZS_ROOT" || exit 1
  echo "Start download the change from github"
  git fetch
  git pull
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
4. Application type:     ${__MYZS__TYPE}
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

  printf '| %-7s | %-20s | %-35s | %-10s |\n' "[index]" "[name]" "[path]" "[status]"

  __myzs_list_modules_internal() {
    local module_name="$1"
    local module_path="${2//$MYZS_ROOT/\$MYZS_ROOT}" # replace path with ROOT variable if possible
    local module_status="$3"
    local module_index="$4"

    printf '| %-7s | %-20s | %-35s | %-10s |\n' "${module_index}" "${module_name}" "${module_path}" "${module_status}"
  }

  _myzs:internal:module:loop __myzs_list_modules_internal

  echo
  printf 'Total %s modules\n' "${#__MYZS__MODULES[@]}"
}

# load modules
# param $1 - module name in src only
#       $2 - string as 'debug' to print debug information
myzs-load() {
  _myzs:internal:module:initial "app/myzs.sh#myzs-load"

  local name="$1" # fully_modules format
  shift 1
  local args=("$@")

  fullpath="${__MYZS__SRC}/${name}"

  if _myzs:internal:module:checker:validate "$name"; then
    if _myzs:internal:module:load "$name" "$fullpath" "${args[@]}"; then
      _myzs:internal:completed
    else
      _myzs:internal:log:warn "loading module return error"
      _myzs:internal:failed 2
    fi
  else
    _myzs:internal:log:warn "invalid modules ($name)"
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
