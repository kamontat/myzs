# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export __MYZS__GROUP_PREFIX="__MYZS_GROUPS__"

# load group data from name
_myzs:internal:group:loader() {
  local group_name="$1"

  echo "$group_name"
}

# create new group with data
_myzs:internal:group:creator() {
  local group_name="$1" elements=()
  shift
  elements=("$@")

  echo "$group_name: ${elements[*]}"
}

_myzs:internal:group:creator "dev" "myzs-plugins/editor#app/vscode.sh" "myzs-plugins/git#alias/git.sh"
