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

# Get timestamp in millisecond
_myzs:internal:timestamp-millisecond() {
  if command -v "gdate" &>/dev/null; then
    gdate +%s%3N
  else
    date +%s000
  fi
}

# $1 = array variable name
# $2 = index (start with 0)
_myzs:internal:remove-array-index() {
  eval "$1=( \"\${$1[@]:0:$2}\" \"\${$1[@]:$(($2 + 1))}\" )"
}

# Get timestamp in second
_myzs:internal:timestamp-second() {
  date +%s
}

_myzs:internal:module:initial() {
  if [[ "$MYZS_DEBUG" == "true" ]]; then
    set -x # enable DEBUG MODE
  fi

  _myzs:internal:log:info "initial module '${__MYZS__CURRENT_MODULE_KEY}' at '$1'"
}

_myzs:internal:module:cleanup() {
  unset __MYZS__CURRENT_MODULE_TYPE __MYZS__CURRENT_MODULE_NAME __MYZS__CURRENT_MODULE_STATUS __MYZS__CURRENT_MODULE_KEY
  _myzs:internal:log:info "cleanup current module settings"
}

# call only in end line of .zshrc file
_myzs:internal:project:cleanup() {
  export __MYZS__FINISH_TIME
  __MYZS__FINISH_TIME="$(date +"%d/%m/%Y %H:%M:%S")"

  _myzs:internal:module:cleanup
  _myzs:internal:metric:log-module

  unset __MYZS__HLP __MYZS__COM
  if [[ "$MYZS_DEBUG" == "true" ]]; then
    set +x # disable DEBUG MODE
  fi
}

_myzs:internal:load() {
  local filename="$1" filepath="$2" exitcode=1
  shift 2
  local args=("$@")

  if _myzs:internal:checker:file-exist "$filepath"; then
    _myzs:internal:log:debug "source ${filepath} with '${args[*]}'"
    source "${filepath}" "${args[@]}"
    exitcode=$?
    if [[ "$exitcode" != "0" ]]; then
      _myzs:internal:log:error "Cannot load ${filename} (${filepath}) because source return $exitcode"
      _myzs:internal:failed "$exitcode"
    else
      _myzs:internal:log:info "Loaded ${filename} (${filepath}) to the system"
      _myzs:internal:completed
    fi
  else
    _myzs:internal:log:warn "Cannot load ${filename} (${filepath}) because file is missing"
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
      fpath+=("$i")
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
