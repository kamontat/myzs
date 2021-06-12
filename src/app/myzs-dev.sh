# shellcheck disable=SC1091,SC2148

myzs:module:new "$0"

myzs-measure() {
  local cmd="$1" exitcode
  shift 1

  myzs:pg:cleanup
  myzs:pg:start

  "$cmd" "$@"
  exitcode="$?"

  myzs:pg:stop "MEASURE_COUNT" "MEASURE_LOADTIME"
  return $exitcode
}

myzs-loadtest() {
  local size="$1" ms=0 avg_10k
  shift 1
  for ((i = 0; i < size; i++)); do
    myzs-measure "$@" >/dev/null
    ((ms += MEASURE_LOADTIME_MS)) # sum loadtime
  done

  avg_10k="$(((ms * 10000) / size))"
  avg="$((ms / size))"
  printf '%-8s: %s.%04dms\n' "total" "$avg" "$((avg_10k - (avg * 10000)))"
  printf '%-8s: %sms\n' "average" "$ms"
}

myzs-debug() {
  local cmd="$1"
  shift 1

  set -x
  "$cmd" "$@"
  set +x
}
