# shellcheck disable=SC1090,SC1091,SC2148

source "${__MYZS__HLP}/database.sh" # load database apis
# source "${__MYZS__HLP}/setting.sh"  # load setting checker
source "${__MYZS__HLP}/setting-v2.sh" # load setting checker v2
source "${__MYZS__HLP}/checker.sh"    # load checker helper
source "${__MYZS__HLP}/logger.sh"     # load logger helper
source "${__MYZS__HLP}/common.sh"     # load all common function

_myzs:internal:load "helper/metric" "${__MYZS__HLP}/metric.sh"       # [extra] load metric
_myzs:internal:load "helper/module" "${__MYZS__HLP}/module.sh"       # [extra] load module
_myzs:internal:load "helper/plugin" "${__MYZS__HLP}/plugin.sh"       # [extra] load plugin
_myzs:internal:load "helper/changelog" "${__MYZS__HLP}/changelog.sh" # [extra] load changelog
_myzs:internal:load "helper/zplug" "${__MYZS__HLP}/zplug.sh"         # [extra] load zplug
