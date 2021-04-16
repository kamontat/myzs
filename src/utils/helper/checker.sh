# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

_myzs:private:checker:shell() {
  if grep -q "$1" <<<"$SHELL"; then
    return 0
  else
    return 1
  fi
}

_myzs:internal:checker:shell:bash() {
  _myzs:private:checker:shell "bash"
}

_myzs:internal:checker:shell:zsh() {
  _myzs:private:checker:shell "zsh"
}

_myzs:internal:checker:shell:fish() {
  _myzs:private:checker:shell "fish"
}

_myzs:internal:checker:command-exist() {
  if command -v "$1" &>/dev/null; then
    _myzs:internal:log:debug "checking command '$1': EXIST"
    return 0
  else
    _myzs:internal:log:debug "checking command '$1': NOT_FOUND"
    return 1
  fi
}

_myzs:internal:checker:file-exist() {
  if test -f "$1"; then
    _myzs:internal:log:debug "checking file '$1': EXIST"
    return 0
  else
    _myzs:internal:log:debug "checking file '$1': NOT_FOUND"
    return 1
  fi
}

_myzs:internal:checker:file-contains() {
  local filename="$1" searching="$2"
  if grep "$searching" "$filename" >/dev/null; then
    _myzs:internal:log:debug "found $searching in $filename file content"
    return 0
  else
    _myzs:internal:log:debug "cannot found $searching in $filename file content"
    return 1
  fi
}

_myzs:internal:checker:folder-exist() {
  if test -d "$1"; then
    _myzs:internal:log:debug "checking folder '$1': EXIST"
    return 0
  else
    _myzs:internal:log:debug "checking folder '$1': NOT_FOUND"
    return 1
  fi
}

_myzs:internal:checker:string-exist() {
  if test -n "$1"; then
    # _myzs:internal:log:debug "Checking string '${1:0:10}': EXIST"
    return 0
  else
    # _myzs:internal:log:warn "Checking string '$1': EMPTY"
    return 1
  fi
}

_myzs:internal:checker:small-type() {
  _myzs:internal:setting:is "myzs/type" "SMALL"
}

_myzs:internal:checker:fully-type() {
  _myzs:internal:setting:is "myzs/type" "FULLY"
}

_myzs:internal:checker:mac() {
  local name
  name="$(uname -s)"
  if [[ "$name" = "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}
