# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export __MYZS__SETTING_PREFIX="__MYZS_SETTINGS__"

_myzs:private:setting:variable() {
  local name="$1"

  echo "$name" | tr "/" "_" | tr "-" "_" | tr "[:lower:]" "[:upper:]"
}

# create settings variable from MYZS_LOADING_SETTINGS
# by change abc/def to ABC_DEF and add prefix as __MYZS_SETTINGS__
# final abc/def=value will transform to __MYZS_SETTINGS__ABC_DEF="value"
myzs:setting:load() {
  local key value variable
  for setting in "${MYZS_LOADING_SETTINGS[@]}"; do
    key="$(_myzs:private:setting:variable "${setting%%#*}")"
    value="${setting##*#}"

    variable="${__MYZS__SETTING_PREFIX}${key}"
    eval "$variable=$value"
  done
}

myzs:setting:is() {
  local name="$1" variable __vtest=""
  shift

  variable="${__MYZS__SETTING_PREFIX}$(_myzs:private:setting:variable "${setting%%#*}")"
  eval "__vtest=\"\$${variable}\""

  for matcher in "$@"; do
    [[ "${__vtest}" == "$matcher" ]] && return 0
  done

  return 1
}

myzs:setting:load
