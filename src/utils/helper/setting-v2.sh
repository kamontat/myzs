# shellcheck disable=SC1090,SC2148

# NOTE: This setting is migrated using database apis, you can found old version at setting.sh

# We using `MYZS_LOADING_SETTINGS` as data storage and compile
# from data array to data variable via method `_myzs:internal:setting:initial`
# with several settings checker method as internal command

# We expose 2 publish commands
#   1. myzs:setting:get "<setting/name>" "<default_value>" - this will return data to stdout
#   2. myzs:setting:get-array "<setting/name>" "<varname>" - this will assign data to input variable name

export __MYZS__SETTING_PREFIX="SETTINGS"

_myzs:internal:setting:initial() {
  _myzs:internal:db:loader "$__MYZS__SETTING_PREFIX" "${MYZS_LOADING_SETTINGS[@]}"
}

# use this when default value is disabled (false)
_myzs:internal:setting:is-enabled() {
  _myzs:internal:db:checker:enabled "$__MYZS__SETTING_PREFIX" "$1"
}

# use this when default value is enabled (true)
_myzs:internal:setting:is-disabled() {
  _myzs:internal:db:checker:disabled "$__MYZS__SETTING_PREFIX" "$1"
}

_myzs:internal:setting:is() {
  _myzs:internal:db:checker:string "$__MYZS__SETTING_PREFIX" "$@"
}

_myzs:internal:setting:greater-than() {
  _myzs:internal:db:checker:greater-than "$__MYZS__SETTING_PREFIX" "$@"
}

_myzs:internal:setting:less-than() {
  _myzs:internal:db:checker:less-than "$__MYZS__SETTING_PREFIX" "$@"
}

_myzs:internal:setting:contains() {
  _myzs:internal:db:checker:contains "$__MYZS__SETTING_PREFIX" "$@"
}

myzs:setting:get() {
  _myzs:internal:db:getter:string "$__MYZS__SETTING_PREFIX" "$@"
}

myzs:setting:get-array() {
  _myzs:internal:db:getter:array "$__MYZS__SETTING_PREFIX" "$@"
}
