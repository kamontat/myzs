# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

myzs:zplug:checker:plugin-installed() {
  local name="$1" # full name from plugin
  _myzs:internal:log:debug "Checking is $name exist in zplug"
  if zplug check "$name"; then
    _myzs:internal:log:info "$name is installed"
    return 0
  else
    _myzs:internal:log:warn "package not exist ($name)"
    return 1
  fi
}
