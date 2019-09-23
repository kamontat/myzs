# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

pg_start() {
  __myzs_debug "start dump progress bar"
}

pg_mark() {
  __myzs_debug "start mark progress bar task as COMPLETED"
}

pg_mark_false() {
  __myzs_debug "start mark progress bar task as FAILURE"
}

pg_stop() {
  __myzs_debug "stop progress bar"
}
