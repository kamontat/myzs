# shellcheck disable=SC1090,SC2148

# This apis if load only if group is enabled

# TODO: implement group modules together and we can load as a group
# This will allow us to deprecate myzs-setup since group will by more understandable and easier to use

myzs:module:new "$0"

export __MYZS__GROUP_PREFIX="group"

# load group list defined from parameters using db:loader
_myzs:internal:group:initial() {
  _myzs:internal:db:loader "$__MYZS__GROUP_PREFIX" "$@"
}

# this is extender/plugin for setter with db:loader command type will refer to
_myzs:internal:group:setter:group() {
  local group_name="$1"
  _myzs:internal:db:setter:array "$__MYZS__GROUP_PREFIX" "$@"

  # append new group name to group list
  _myzs:internal:db:append:array "$__MYZS__GROUP_PREFIX" "list" "$group_name"

  return 0
}

# load module from group into main commandline
_myzs:internal:group:load() {
  local group_name="$1" groups=() module_list=()
  _myzs:internal:db:getter:array "$__MYZS__GROUP_PREFIX" "list" groups
  if ! grep -q "$group_name" <<<"${groups[@]}"; then
    return 1
  fi

  _myzs:internal:db:getter:array "$__MYZS__GROUP_PREFIX" "$group_name" module_list

  for module in "${module_list[@]}"; do
    _myzs:internal:module:load "$module"
  done
}
