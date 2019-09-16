# shellcheck disable=SC1090,SC2148

export _PLUGINS_WD_GIT_URL="https://github.com/mfaerevaag/wd.git"
export _PLUGINS_WD_HOME="${ZGEN_HOME}/mfaerevaag/wd-master"

if is_command_exist "git" && ! is_folder_exist "$_PLUGINS_WD_HOME"; then
  git clone "$_PLUGINS_WD_GIT_URL" "$_PLUGINS_WD_HOME" --quiet
fi

if is_file_exist "${ZGEN_HOME}/mfaerevaag/wd-master/wd.sh"; then
  export wd

  wd() {
    source "${ZGEN_HOME}/mfaerevaag/wd-master/wd.sh"
  }
fi
