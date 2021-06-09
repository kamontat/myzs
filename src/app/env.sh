# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

# load environment
export __MYZS__ENVFILE="$_MYZS_ROOT/.env"
if _myzs:internal:checker:file-exist "$__MYZS__ENVFILE"; then
  myzs:pg:step "Helper" "Loaded environment variable"

  myzs:module:new "$__MYZS__ENVFILE"

  env_list=()
  while IFS= read -r line; do
    key="${line%=*}"
    value="${line##*=}"

    if _myzs:internal:checker:string-exist "$key" && _myzs:internal:checker:string-exist "$value"; then
      env_list+=("$key")
      # shellcheck disable=SC2163
      export "${key}"="${value}"
    fi
  done <"$__MYZS__ENVFILE"
  [[ ${#env_list[@]} -gt 0 ]] && _myzs:internal:log:info "exporting [ ${env_list[*]} ]"
  unset line env_list
fi
