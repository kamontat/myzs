# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

# Usage: _myzs:internal:shell [zsh_string] [bash_string]
# Ex1:   _myzs:internal:shell             => zsh|bash
# Ex2:   _myzs:internal:shell "z" "b" => z|b
_myzs:internal:shell() {
  local zsh="${1:-zsh}" bash="${1:-bash}"
  if _myzs:internal:checker:shell:zsh; then
    echo "$zsh"
  elif _myzs:internal:checker:shell:bash; then
    echo "$bash"
  fi
}

# Get timestamp in second
_myzs:internal:timestamp-second() {
  date +%s
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

myzs:module:new() {
  _myzs:internal:log:info "initial module '${__MYZS__CURRENT_MODULE_KEY}' at '$1'"
}

_myzs:internal:module:cleanup() {
  local key="$1"

  _myzs:internal:log:info "cleanup current module settings (${key:-$__MYZS__CURRENT_MODULE_KEY})"
  unset __MYZS__CURRENT_MODULE_TYPE __MYZS__CURRENT_MODULE_NAME __MYZS__CURRENT_MODULE_STATUS __MYZS__CURRENT_MODULE_KEY

  # Always disable DEBUG MODE
  set +x # disable DEBUG MODE
}

# call only in end line of .zshrc file
_myzs:internal:project:cleanup() {
  export __MYZS__FINISH_TIME
  __MYZS__FINISH_TIME="$(date +"%d/%m/%Y %H:%M:%S")"

  _myzs:internal:module:cleanup
  _myzs:internal:call metric:log-module
}

_myzs:internal:load() {
  local filename="$1" filepath="$2" exitcode=1
  shift 2
  local args=("$@")

  if _myzs:internal:checker:file-exist "$filepath"; then
    # _myzs:internal:log:debug "source ${filepath} with '${args[*]}'"
    source "${filepath}" "${args[@]}"
    exitcode=$?
    if [[ "$exitcode" != "0" ]]; then
      _myzs:internal:log:error "Cannot load ${filename} (${filepath}) because source return $exitcode"
      return "$exitcode"
    else
      # _myzs:internal:log:info "Loaded ${filename} (${filepath}) to the system"
      return 0
    fi
  else
    _myzs:internal:log:warn "Cannot load ${filename} (${filepath}) because file is missing"
    return 4
  fi
}

_myzs:internal:alias() {
  if ! _myzs:internal:checker:command-exist "$1"; then
    # _myzs:internal:log:info "Add $1 as alias of $2"
    # shellcheck disable=SC2139
    alias "$1"="$2"
  fi
}

_myzs:internal:alias-force() {
  # _myzs:internal:log:info "Add $1 as alias of $2 (force)"
  # shellcheck disable=SC2139
  alias "$1"="$2"
}

_myzs:internal:fpath-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i" || _myzs:internal:checker:file-exist "$i"; then
      # _myzs:internal:log:info "Add $i to fpath environment"
      fpath+=("$i")
    fi
  done
}

_myzs:internal:manpath-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i" || _myzs:internal:checker:file-exist "$i"; then
      # create default manpath if manpath is empty string
      if ! _myzs:internal:checker:string-exist "$MANPATH"; then
        if _myzs:internal:checker:mac; then
          MANPATH="$(manpath -w):$i"
        else
          MANPATH="$(manpath -g):$i"
        fi
      fi

      export MANPATH="$MANPATH:$i"
    fi
  done
}

_myzs:internal:path-push() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i"; then
      if ! [[ "$PATH" == *"$i"* ]]; then
        # _myzs:internal:log:info "Push $i to PATH environment"
        export PATH="$PATH:$i"
      fi
    fi
  done
}

_myzs:internal:path-append() {
  for i in "$@"; do
    if _myzs:internal:checker:folder-exist "$i"; then
      if ! [[ "$PATH" == *"$i"* ]]; then
        # _myzs:internal:log:info "Append $i to PATH environment"
        export PATH="$i:$PATH"
      fi
    fi
  done
}
