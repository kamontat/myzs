# shellcheck disable=SC1090,SC1091,SC2148

# preload after common apis available
source "${__MYZS__UTL}/preload.sh"    # internal call
source "${__MYZS__UTL}/database.sh"   # load database apis
source "${__MYZS__UTL}/setting-v2.sh" # load setting checker v2
source "${__MYZS__UTL}/checker.sh"    # load checker helper
source "${__MYZS__UTL}/logger.sh"     # load logger helper
source "${__MYZS__UTL}/common.sh"     # load all common function

_myzs:internal:setting:initial

# direct load from common apis
_myzs:internal:load "helper/module" "${__MYZS__UTL}/module.sh" # load module
myzs:module:new "$0"

# After this will load using module apis
_myzs:internal:setting:is-enabled "group" &&
  _myzs:internal:module:load "builtin#utils/group.sh" # [extra] load group apis
_myzs:internal:setting:is-enabled "metrics" &&
  _myzs:internal:module:load "builtin#utils/metric.sh" # [extra] load metric

_myzs:internal:module:load "builtin#utils/plugin-v2.sh" # [extra] load plugin (v2)
_myzs:internal:module:load "builtin#utils/changelog.sh" # [extra] load changelog
_myzs:internal:module:load "builtin#utils/zplug.sh"     # [extra] load zplug
