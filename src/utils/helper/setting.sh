# shellcheck disable=SC1090,SC2148

# 1. String | Number
#    - Data storage: "${__MYZS__SETTING_PREFIX}${NAME}=${VALUE}"
#                    e.g. __MYZS_SETTINGS__MODULE_NAME="setting"
#    - Data access:  using `_myzs:internal:setting:is "${NAME}" "${VALUE}"`
#                    e.g. _myzs:internal:setting:is "module/name" "setting"
# 2. Boolean
#    - Data storage: using myzs:settings:loading(loader enabled disabled) enabled and disabled method
#                    e.g. enabled "module-loader"

export __MYZS__SETTING_PREFIX="__MYZS_SETTINGS__"

# All boolean settings will prefix with _ENABLED / _DISABLED and value will always be true
# e.g. _myzs:internal:setting:is-enabled "analytics" will try to query from $__MYZS_SETTINGS__ANALYTICS_ENABLED must be 'true'

_myzs:private:setting:variable() {
  local name="$1"

  echo "$name" | tr "/" "_" | tr "-" "_" | tr "[:lower:]" "[:upper:]"
}

_myzs:private:setting:setup() {
  local variable key value

  key="$(_myzs:private:setting:variable "$1")"
  value="$2"

  variable="${__MYZS__SETTING_PREFIX}${key}"
  eval "$variable=$value"
}

_myzs:private:setting:enabled() {
  _myzs:private:setting:setup "$1" "true"
}

_myzs:private:setting:disabled() {
  _myzs:private:setting:setup "$1" "false"
}

_myzs:private:setting:array() {
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
  local args=()
  local key value variable setting

  for setting in "${MYZS_LOADING_SETTINGS[@]}"; do
    if [[ "${setting}" == "$" ]]; then
      if [[ "${#args[@]}" -gt 0 ]]; then
        # shellcheck disable=SC2145
        "_myzs:private:setting:${args[@]}"
        args=()
      fi
    else
      args+=("$setting")
    fi
  done

  # for final command
  if [[ "${#args[@]}" -gt 0 ]]; then
    # shellcheck disable=SC2145
    "_myzs:private:setting:${args[@]}"
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
