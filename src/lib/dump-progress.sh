# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

myzs:pg:start() {
  _myzs:internal:log:debug "start dump progress bar"
}

myzs:pg:step() {
  _myzs:internal:log:debug "[PG-COMPLETED] $*"
}

myzs:pg:msg() {
  _myzs:internal:log:debug "[PG-CHANGE] $*"
}

myzs:pg:mark-fail() {
  _myzs:internal:log:debug "[PG-FAILURED] $*"
}

myzs:pg:step-skip() {
  _myzs:internal:log:debug "[PG-SKIPPED] $*"
}

myzs:pg:stop() {
  _myzs:internal:log:debug "stop progress bar"
}

myzs:pg:cleanup() {
  _myzs:internal:log:debug "cleanup progress bar"
}
