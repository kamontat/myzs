# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0" "force"

myzs:pg:start() {
  _myzs:internal:log:debug "start dump progress bar"
}

myzs:pg:mark() {
  _myzs:internal:log:debug "start mark progress bar task as COMPLETED"
}

myzs:pg:mark-fail() {
  _myzs:internal:log:debug "start mark progress bar task as FAILURE"
}

myzs:pg:stop() {
  _myzs:internal:log:debug "stop progress bar"
}
