# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

initial() {
  local _gcloud_default_name="${1:-google-cloud-sdk}"

  local _gcloud_default1="/opt"              # application location
  local _gcloud_default2="/usr/local/Cellar" # homebrew location
  local _gcloud_default3="/usr/local/bin"    # legacy location

  _myzs:internal:checker:folder-exist "$_gcloud_default1/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default1/${_gcloud_default_name}"

  _myzs:internal:checker:folder-exist "$_gcloud_default2/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default2/${_gcloud_default_name}"

  _myzs:internal:checker:folder-exist "$_gcloud_default3/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default3/${_gcloud_default_name}"

  _myzs:internal:checker:folder-exist "${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="${_gcloud_default_name}"

  local current_path="${__MYZS__DEFAULT_GCLOUD_LOCATION}"
  _myzs:internal:checker:command-exist "gcloud" &&
    current_path="$(dirname "$(dirname "$(which gcloud)")")"

  local gcloud_path="${current_path:-$default_path}"

  _myzs:internal:path-push "${gcloud_path}/bin"
  # The next line enables shell command completion for gcloud.
  _myzs:internal:load "Google Cloud SDK path" "${gcloud_path}/completion.$(_myzs:internal:shell).inc"

  if ! _myzs:internal:checker:command-exist "gcloud"; then
    if _myzs:internal:checker:string-exist "$__MYZS__DEFAULT_GCLOUD_LOCATION"; then
      _myzs:internal:log:info "loading gcloud from ${__MYZS__DEFAULT_GCLOUD_LOCATION}"

      local install_path="${__MYZS__DEFAULT_GCLOUD_LOCATION}/install.sh"
      $install_path
    else
      _myzs:internal:log:info "cannot found gcloud-sdk location, create \$MYZS_GCLOUD_LOCATION and point to gcloud-sdk location path"
      _myzs:internal:failed 2
    fi
  else
    _myzs:internal:log:info "command gcloud already existed, skip initial"
  fi
}

initial "$MYZS_GCLOUD_LOCATION"
