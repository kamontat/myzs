#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by 2.3.2
# link (https://github.com/Template-generator/script-genrating/tree/2.3.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

# You must execute this with source "deploy-plugins.sh" since this script will depend on myzs function

upload() {
  local plugin_name="$1"

  local plugin_folder="${__MYZS__PLG}"
  local plugin_path="${plugin_folder}/$plugin_name"

  if _myzs:internal:checker:folder-exist "${plugin_path}"; then
    cd "${plugin_path}" || exit 1

    echo "[$((index + 1))/$size]  - report status"
    git status --short

    echo "[$((index + 2))/$size]  - add all changes to plugin git"
    git add .

    echo "[$((index + 3))/$size]  - commit all changes with release note"
    git commit --allow-empty -m "chore(release): automatic commit process"

    echo "[$((index + 4))/$size]  - push all changes to Github repository"
    git push
  else
    _myzs:internal:log:error "Plugin ${plugin_name} is not found at path ${plugin_path}" >&2
  fi
}

size=$((${#MYZS_LOADING_PLUGINS[@]} * 5))
index=1
for plugin in "${MYZS_LOADING_PLUGINS[@]}"; do
  echo "[$index/$size] update plugin ${plugin}"
  if ! _myzs:internal:plugin:name-deserialize "$plugin" upload; then
    echo "Cannot load plugin"
  fi

  index=$((index + 5))
done
