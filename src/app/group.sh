# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export __MYZS__GROUP_PREFIX="__MYZS_GROUPS__"

_myzs:internal:group:get() {
  echo ""
}

# TODO: Implement group module loading with mg | myzs-group command
# echo "grouping"
