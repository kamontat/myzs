# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0" "force"

myzs:pg:start() {
  _myzs:internal:log:debug "start dump progress bar"
}

myzs:pg:mark() {
  _myzs:internal:log:debug "[PG-COMPLETED] $*"
}

myzs:pg:mark-fail() {
  _myzs:internal:log:debug "[PG-FAILURED] $*"
}

myzs:pg:stop() {
  _myzs:internal:log:debug "stop progress bar"
}

myzs:pg:cleanup() {
  _myzs:internal:log:debug "cleanup progress bar"
}