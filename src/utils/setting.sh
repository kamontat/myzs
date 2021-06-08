# shellcheck disable=SC1090,SC2148

# We using `MYZS_LOADING_SETTINGS` as data storage and compile
# from data array to data variable via method `_myzs:internal:setting:initial`
# with several settings checker method as internal command

# We expose 2 publish commands
#   1. myzs:setting:get "<setting/name>" "<default_value>" - this will return data to stdout
#   2. myzs:setting:get-array "<setting/name>" "<varname>" - this will assign data to input variable name

export __MYZS__SETTING_PREFIX="__MYZS_SETTINGS__"

# will log only logger method is loaded to memory
_myzs:private:setting:debug() {
  # cannot use myzs command since it might not initial
  if command -v "_myzs:internal:log:debug" >/dev/null; then
    _myzs:internal:log:debug "$@"
  fi
}

_myzs:private:setting:variable() {
  local name="$1"

  echo "$name" |
    tr "/" "_" |
    tr "-" "_" |
    tr "[:lower:]" "[:upper:]" |
    tr -d "$" |
    tr -d "&" |
    tr -d "|" |
    tr -d ";" # remove $ & | ; <- to avoid injection
}

# Add data as primitive type
_myzs:private:setting:set:setup() {
  local variable key value

  key="$(_myzs:private:setting:variable "$1")"
  value="$2"

  # _myzs:private:setting:debug "settings $1='$2'"
  variable="${__MYZS__SETTING_PREFIX}${key}"
  eval "$variable=$value"
}

_myzs:private:setting:set:string() {
  _myzs:private:setting:set:setup "$1" "$2"
}

# Add data as true $1 setting name
_myzs:private:setting:set:enabled() {
  _myzs:private:setting:set:setup "$1" "true"
}

# Add data as false $1 setting name
_myzs:private:setting:set:disabled() {
  _myzs:private:setting:set:setup "$1" "false"
}

# Add data as array
_myzs:private:setting:set:array() {
  local key value="" variable

  key="$(_myzs:private:setting:variable "$1")"
  shift 1

  for data in "$@"; do
    if test -z "$value"; then
      value="\"$data\""
    else
      value="$value \"$data\""
    fi
  done

  _myzs:private:setting:debug "initial settings array ($1)"
  variable="${__MYZS__SETTING_PREFIX}${key}"
  eval "$variable=($value)"
}

_myzs:private:setting:checker() {
  local cmd="$1" name="$2" __vtest=""
  shift 2

  __vtest="$(myzs:setting:get "$name")"
  for matcher in "$@"; do
    if "$cmd" "${__vtest}" "$matcher"; then
      return 0
    fi
  done

  return 1
}

# create settings variable from MYZS_LOADING_SETTINGS
# by change abc/def to ABC_DEF and add prefix as __MYZS_SETTINGS__
# final abc/def=value will transform to __MYZS_SETTINGS__ABC_DEF="value"
_myzs:internal:setting:initial() {
  local command_prefix="_myzs:private:setting:set" args=()
  local key value variable setting

  for setting in "${MYZS_LOADING_SETTINGS[@]}"; do
    if [[ "${setting}" == "$" ]]; then
      if [[ "${#args[@]}" -gt 0 ]]; then
        # shellcheck disable=SC2145
        "${command_prefix}:${args[@]}"
        args=()
      fi
    else
      args+=("$setting")
    fi
  done

  # for final command
  if [[ "${#args[@]}" -gt 0 ]]; then
    # shellcheck disable=SC2145
    "${command_prefix}:${args[@]}"
  fi
}

# use this when default value is disabled (false)
_myzs:internal:setting:is-enabled() {
  _myzs:internal:setting:is "$1" "true"
}

# use this when default value is enabled (true)
_myzs:internal:setting:is-disabled() {
  _myzs:internal:setting:is "$1" "false"
}

_myzs:private:setting:is() {
  local data="$1" checker="$2"
  [[ "$data" == "$checker" ]]
}
_myzs:internal:setting:is() {
  _myzs:private:setting:checker "_myzs:private:setting:is" "$@"
}

_myzs:private:setting:greater-than() {
  local data="$1" checker="$2"
  [[ "$data" -gt "$checker" ]]
}
# $setting > $B && $setting > $C ...
_myzs:internal:setting:greater-than() {
  _myzs:private:setting:checker "_myzs:private:setting:greater-than" "$@"
}

_myzs:private:setting:less-than() {
  local data="$1" checker="$2"
  [[ "$data" -lt "$checker" ]]
}
# $setting < $B && $setting < $C ...
_myzs:internal:setting:less-than() {
  _myzs:private:setting:checker "_myzs:private:setting:less-than" "$@"
}

_myzs:private:setting:contains() {
  local data="$1" checker="$2"
  echo "${data}" | grep -iqF "$checker"
}
# 'a b c' contains 'a' && 'a b c' contains 'b'
_myzs:internal:setting:contains() {
  _myzs:private:setting:checker "_myzs:private:setting:contains" "$@"
}

myzs:setting:get() {
  local name="$1" fallback="$2" variable __vtest=""

  variable="${__MYZS__SETTING_PREFIX}$(_myzs:private:setting:variable "${name}")"
  eval "__vtest=\"\${${variable}:-$fallback}\""

  echo "$__vtest"
}

myzs:setting:get-array() {
  local name="$1" varname="$2" variable __vtest=""

  variable="${__MYZS__SETTING_PREFIX}$(_myzs:private:setting:variable "${name}")"
  eval "$varname=(\${${variable}})"
}
