# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

_myzs:private:gcloud:initial() {
  local _local_shell _gcloud_fullpath
  _local_shell="$(_myzs:internal:shell)"
  local _path_filename="path.$_local_shell.inc"
  local _completion_filename="completion.$_local_shell.inc"
  local _gcloud_default_name="google-cloud-sdk"
  local _gcloud_paths=(
    "/opt"
    "/usr/local/Cellar"
    "/usr/local/bin"
    "/usr/local/etc"
  )

  export __MYZS__DEFAULT_GCLOUD_DIRPATH=""
  for _gcloud_path in "${_gcloud_paths[@]}"; do
    _gcloud_fullpath="$_gcloud_path/$_gcloud_default_name"
    if _myzs:internal:checker:folder-exist "$_gcloud_fullpath"; then
      __MYZS__DEFAULT_GCLOUD_DIRPATH="$_gcloud_fullpath"
    fi
  done

  if _myzs:internal:checker:string-exist "$__MYZS__DEFAULT_GCLOUD_DIRPATH"; then
    _myzs:internal:log:debug "loading gcloud from ${__MYZS__DEFAULT_GCLOUD_DIRPATH}"

    _myzs:internal:load "Google Cloud SDK path" "$__MYZS__DEFAULT_GCLOUD_DIRPATH/$_path_filename"
    _myzs:internal:load "Google Cloud SDK completion" "$__MYZS__DEFAULT_GCLOUD_DIRPATH/$_completion_filename"
  fi
}

_myzs:private:gcloud:initial
