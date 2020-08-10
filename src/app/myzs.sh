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

Hello, My name is myzs. I'm a configuable shell settings.
I was created by $__MYZS_OWNER since $__MYZS_SINCE.
My owner actively upgrade myself as much as possible, 
and now my upgraded version is $__MYZS_VERSION which updated from ${__MYZS_LAST_UPDATED}
I'm holding license '${__MYZS_LICENSE}' which mean you can do everything that license allow.
Most of my application files stay on ${__MYZS_ROOT}
and log message will produce to ${MYZS_LOGPATH}.
"

  myzs-list-changelogs
  myzs-list-modules
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

  local mod reg1 reg2 reg3 filename filepath filestatus raw raw1

  reg1="\{1\{([^\{\}]+)\}\}"
  reg2="\{2\{([^\{\}]+)\}\}"
  reg3="\{3\{(pass|fail|skip)\}\}"

  printf '| %-20s | %-35s | %-10s |\n' "[name]" "[path]" "[status]"

  for mod in "${__MYZS_MODULES[@]}"; do
    raw="$(echo "$mod" | grep -Eoi "${reg1}")"
    raw1="${raw//\{1\{/}"
    filename="${raw1//\}\}/}"

    raw="$(echo "$mod" | grep -Eo "${reg2}")"
    raw1="${raw//\{2\{/}"
    filepath="${raw1//\}\}/}"
    filepath="${filepath//$MYZS_ROOT/\$MYZS_ROOT}"

    raw="$(echo "$mod" | grep -Eoi "${reg3}")"
    raw1="${raw//\{3\{/}"
    filestatus="${raw1//\}\}/}"

    printf '| %-20s | %-35s | %-10s |\n' "${filename}" "${filepath}" "${filestatus}"
  done

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

  if __myzs_load_module "$name" "$fullpath"; then
    __myzs_is_string_exist "$debug" && echo "loaded"
  fi
}

# run myzs load set file: $PWD/.myzs-setup
myzs-setup-local() {
  __myzs_initial "app/myzs.sh#myzs-setup-local"

  local fullpath="$PWD/.myzs-setup"
  __myzs_load "local-setup" "$fullpath"
}
