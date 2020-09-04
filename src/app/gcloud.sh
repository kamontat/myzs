# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

initial() {
  local _gcloud_default_name="${1:-google-cloud-sdk}"

  local _gcloud_default1="/opt"              # application location
  local _gcloud_default2="/usr/local/Cellar" # homebrew location
  local _gcloud_default3="/usr/local/bin"    # legacy location

  __myzs_is_folder_exist "$_gcloud_default1/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default1/${_gcloud_default_name}"

  __myzs_is_folder_exist "$_gcloud_default2/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default2/${_gcloud_default_name}"

  __myzs_is_folder_exist "$_gcloud_default3/${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="$_gcloud_default3/${_gcloud_default_name}"

  __myzs_is_folder_exist "${_gcloud_default_name}" &&
    export __MYZS__DEFAULT_GCLOUD_LOCATION="${_gcloud_default_name}"

  local current_path="${__MYZS__DEFAULT_GCLOUD_LOCATION}"
  __myzs_is_command_exist "gcloud" &&
    current_path="$(dirname "$(dirname "$(which gcloud)")")"

  local gcloud_path="${current_path:-$default_path}"

  __myzs_push_path "${gcloud_path}/bin"
  # The next line enables shell command completion for gcloud.
  __myzs_load "Google Cloud SDK path" "${gcloud_path}/completion.$(__myzs_on_shell).inc"

  if ! __myzs_is_command_exist "gcloud"; then
    if __myzs_is_string_exist "$__MYZS__DEFAULT_GCLOUD_LOCATION"; then
      __myzs_info "loading gcloud from ${__MYZS__DEFAULT_GCLOUD_LOCATION}"

      local install_path="${__MYZS__DEFAULT_GCLOUD_LOCATION}/install.sh"
      $install_path
    else
      __myzs_info "cannot found gcloud-sdk location, create \$MYZS_GCLOUD_LOCATION and point to gcloud-sdk location path"
      __myzs_failure 2
    fi
  else
    __myzs_info "command gcloud already existed, skip initial"
  fi
}

initial "$MYZS_GCLOUD_LOCATION"
