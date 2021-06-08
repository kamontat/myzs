# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

_myzs:internal:call() {
  local prefix="_myzs:internal" name="$1" method
  method="$prefix:$name"
  shift

  # call internal method only if it exist
  if command -v "$method" >/dev/null; then
    "$method" "$@"
  fi
}

_myzs:internal:call-or() {
  local prefix="_myzs:internal" name="$1" fallback="$2" method
  method="$prefix:$name"
  shift 2

  # call internal method only if it exist
  if command -v "$method" >/dev/null; then
    "$method" "$@"
  else
    "$fallback" "$@"
  fi
}
