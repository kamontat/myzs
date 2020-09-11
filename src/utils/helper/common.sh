# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

_myzs:private:return() {
  return "$1"
}

_myzs:internal:completed() {
  _myzs:private:return "0"
}

_myzs:internal:failed() {
  _myzs:private:return "${1:-1}"
}

# Usage: _myzs:internal:shell [zsh_string] [bash_string] [fish_string]
# Ex1:   _myzs:internal:shell             => zsh|bash|fish
# Ex2:   _myzs:internal:shell "z" "b" "f" => z|b|f
_myzs:internal:shell() {
  local zsh="${1:-zsh}" bash="${1:-bash}" fish="${1:-fish}"
  if _myzs:internal:checker:shell:zsh; then
    echo "$zsh"
  elif _myzs:internal:checker:shell:bash; then
    echo "$bash"
  elif _myzs:internal:checker:shell:fish; then
    echo "$fish"
  fi
}

_myzs:internal:module:initial() {
  if [[ "$MYZS_DEBUG" == "true" ]]; then
    set -x # enable DEBUG MODE
  fi

  local filename
  filename="$(basename "$1")"
  if [[ "$2" == "force" ]]; then
    export __MYZS__CURRENT_FILENAME="$filename"
  else
    export __MYZS__CURRENT_FILENAME="${__MYZS__CURRENT_FILENAME:-$filename}"
  fi

  # _myzs:internal:log:info "start new modules"
}

_myzs:internal:module:cleanup() {
  unset __MYZS__CURRENT_FILENAME __MYZS__CURRENT_FILEPATH __MYZS__CURRENT_STATUS
  unset MYZS_SETTINGS_WELCOME_MESSAGE MYZS_START_COMMAND MYZS_START_COMMAND_ARGUMENTS

  # _myzs:internal:log:info "cleanup application"
}

# call only in end line of .zshrc file
_myzs:internal:project:cleanup() {
  export __MYZS__FINISH_TIME
  __MYZS__FINISH_TIME="$(date +"%d/%m/%Y %H:%M:%S")"

  _myzs:internal:module:cleanup
  _myzs:internal:metric:saved

  if [[ "$MYZS_DEBUG" == "true" ]]; then
    set +x # disable DEBUG MODE
  fi
}

_myzs:internal:load() {
  local _name="$1" _path="$2" exitcode=1
  shift 2
  local args=("$@")
  if _myzs:internal:checker:file-exist "$_path"; then
    source "${_path}" "${args[@]}"
    exitcode=$?
    if [[ "$exitcode" != "0" ]]; then
      _myzs:internal:log:error "Cannot load ${_name} (${_path}) because source return $exitcode"
      _myzs:internal:failed "$exitcode"
    fi

    _myzs:internal:log:info "Loaded ${_name} (${_path}) to the system"
    _myzs:internal:completed
  else
    _myzs:internal:log:warn "Cannot load ${_name} (${_path}) because file is missing"
    _myzs:internal:failed 4
  fi
}

_myzs:internal:alias() {
  if _myzs:internal:checker:command-exist "$1"; then
    _myzs:internal:log:warn "Cannot Add $1 alias because [command exist]"
  else
    _myzs:internal:log:info "Add $1 as alias of $2"
    # shellcheck disable=SC2139
    alias "$1"="$2"
  fi
}

_myzs:internal:alias-force() {
  _myzs:internal:log:info "Add $1 as alias of $2 (force)"
  # shellcheck disable=SC2139
  alias "$1"="$2"
}

_myzs:internal:fpath-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i" || _myzs:internal:checker:file-exist "$i"; then
      _myzs:internal:log:info "Add $i to fpath environment"
      export fpath+=("$i")
    else
      _myzs:internal:log:warn "Cannot add $i to fpath environment because folder or file is missing"
    fi
  done
}

_myzs:internal:manpath-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i" || _myzs:internal:checker:file-exist "$i"; then
      _myzs:internal:log:info "Add $i to MANPATH environment"
      export MANPATH="$MANPATH:$i"
    else
      _myzs:internal:log:warn "Cannot add $i to MANPATH environment because folder or file is missing"
    fi
  done
}

_myzs:internal:path-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i"; then
      if [[ "$PATH" == *"$i"* ]]; then
        _myzs:internal:log:warn "$i path is already exist to \$PATH"
      else
        _myzs:internal:log:info "Push $i to PATH environment"
        export PATH="$PATH:$i"
      fi
    else
      _myzs:internal:log:warn "Cannot add $i to PATH environment because folder is missing"
    fi
  done
}

_myzs:internal:path-append() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i"; then
      if [[ "$PATH" == *"$i"* ]]; then
        _myzs:internal:log:warn "$i path is already exist to \$PATH"
      else
        _myzs:internal:log:info "Append $i to PATH environment"
        export PATH="$i:$PATH"
      fi
    else
      _myzs:internal:log:warn "Cannot add $i to PATH environment because folder is missing"
    fi
  done
}