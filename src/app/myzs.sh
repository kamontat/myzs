# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

myzs-upload() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  cd "$MYZS_ROOT" || exit 1
  echo "Start upload current change to github"
  git status --short
  ./deploy.sh
}

myzs-download() {
  test -z "$MYZS_ROOT" && echo "\$MYZS_ROOT is required" && exit 2

  cd "$MYZS_ROOT" || exit 1
  echo "Start download the change from github"
  git fetch
  git pull
}

myzs-list-modules() {
  test -z "${__MYZS_MODULES[*]}" && echo "Cannot find any modules exist" && exit 2

  local mod reg1 reg2 reg3 filename filepath filestatus raw raw1

  reg1="\{1\{([^\{\}]+)\}\}"
  reg2="\{2\{([^\{\}]+)\}\}"
  reg3="\{3\{(pass|fail|skip)\}\}"

  printf '| %-15s | %-35s | %-10s |\n' "[name]" "[path]" "[status]"

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

    printf '| %-15s | %-35s | %-10s |\n' "${filename}" "${filepath}" "${filestatus}"
  done

  echo
  printf 'Total %s modules\n' "${#__MYZS_MODULES[@]}"
}
