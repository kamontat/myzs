# shellcheck disable=SC1090,SC1091,SC2148

source "${__MYZS__UTL}/preload.sh"    # internal call
source "${__MYZS__UTL}/database.sh"   # load database apis
# source "${__MYZS__UTL}/setting.sh"    # load setting checker
source "${__MYZS__UTL}/setting-v2.sh" # load setting checker v2
source "${__MYZS__UTL}/checker.sh"    # load checker helper
source "${__MYZS__UTL}/logger.sh"     # load logger helper
source "${__MYZS__UTL}/common.sh"     # load all common function

_myzs:internal:load "helper/metric" "${__MYZS__UTL}/metric.sh"       # [extra] load metric
_myzs:internal:load "helper/module" "${__MYZS__UTL}/module.sh"       # [extra] load module
# _myzs:internal:load "helper/plugin" "${__MYZS__UTL}/plugin.sh"       # [extra] load plugin
_myzs:internal:load "helper/plugin" "${__MYZS__UTL}/plugin-v2.sh"    # [extra] load plugin (v2)
_myzs:internal:load "helper/changelog" "${__MYZS__UTL}/changelog.sh" # [extra] load changelog
_myzs:internal:load "helper/zplug" "${__MYZS__UTL}/zplug.sh"         # [extra] load zplug
