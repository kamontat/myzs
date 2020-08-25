# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

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
2. Application location: ${__MYZS_ROOT}
3. Application version:  ${__MYZS_VERSION}
4. Application type:     ${__MYZS_TYPE}
5. Log location:         ${MYZS_LOGPATH}
6. Loading time:         ${PROGRESS_LOADTIME}
7. Loaded time:          ${__MYZS_FINISH_TIME}

## Credit

Created by '$__MYZS_OWNER'
Since      '$__MYZS_SINCE' => '$__MYZS_LAST_UPDATED'
License    '$__MYZS_LICENSE'
"
}

myzs-list-changelogs() {
  echo "# Release notes"
  echo

  if test -z "${__MYZS_CHANGELOGS[*]}"; then
    echo "Cannot found any notes"
  else
    local size version date changelog

    size="${#__MYZS_CHANGELOGS[@]}"

    for ((i = 1; i < size; i += 3)); do
      version="${__MYZS_CHANGELOGS[i]}"
      date="${__MYZS_CHANGELOGS[i + 1]}"
      changelog="${__MYZS_CHANGELOGS[i + 2]}"

      echo "## Version $version ($date)"
      echo
      echo "$changelog"
      echo
    done
  fi
}

myzs-list-modules() {
  echo "# Modules"
  echo

  ! __myzs_is_string_exist "${__MYZS_MODULES[*]}" && echo "Cannot find any modules exist" && exit 2

  printf '| %-7s | %-20s | %-35s | %-10s |\n' "[index]" "[name]" "[path]" "[status]"

  __myzs_list_modules_internal() {
    local module_name="$1"
    local module_path="$2"
    local module_status="$3"
    local module_index="$4"

    printf '| %-7s | %-20s | %-35s | %-10s |\n' "${module_index}" "${module_name}" "${module_path}" "${module_status}"
  }

  __myzs_loop_modules __myzs_list_modules_internal

  echo
  printf 'Total %s modules\n' "${#__MYZS_MODULES[@]}"
}

# load modules
# param $1 - module name in src only
#       $2 - string as 'debug' to print debug information
myzs-load() {
  __myzs_initial "app/myzs.sh#myzs-load"

  local name="$1" # fully_modules format
  local debug="$2"

  fullpath="${__MYZS_SOURCE_CODE}/${name}"

  __myzs_is_string_exist "$debug" && echo "input name: $name"
  __myzs_is_string_exist "$debug" && echo "input path: $fullpath"

  if __myzs__is_valid_module "$name"; then
    if __myzs_load_module "$name" "$fullpath"; then
      __myzs_is_string_exist "$debug" && echo "loaded"
      __myzs_complete
    else
      __myzs_is_string_exist "$debug" && echo "loading module return error" >&2
      __myzs_failure 2
    fi
  else
    __myzs_is_string_exist "$debug" && echo "invalid modules ($name)" >&2
    __myzs_failure 3
  fi
}

# run myzs load set file: $PWD/.myzs-setup
myzs-setup-local() {
  __myzs_initial "app/myzs.sh#myzs-setup-local"

  local fullpath="$PWD/.myzs-setup"
  __myzs_load "local-setup" "$fullpath"
}
