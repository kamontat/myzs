# shellcheck disable=SC1090,SC2148

export USER="$MYZS_USER"
export DEFAULT_USER="$USER"

export MANPATH="/usr/local/man:$MANPATH"

java_wrapper="$HOME/.asdf/plugins/java/asdf-java-wrapper.zsh"
if is_file_exist "${java_wrapper}"; then
  source "${java_wrapper}"
elif is_file_exist "/usr/libexec/java_home"; then
  JAVA_HOME="$(/usr/libexec/java_home)"
  export JAVA_HOME

  export PATH="$PATH:$JAVA_HOME/bin"
fi

if is_command_exist "jenv"; then
  eval "$(jenv init -)"
  if is_folder_exist "$HOME/.jenv/bin"; then
    export PATH="$PATH:$HOME/.jenv/bin"
  fi
fi

if is_folder_exist "$HOME/Library/Android/sdk"; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"                      # android home
  export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools" # android path
fi

if is_command_exist "yarn" && is_folder_exist "$HOME/.config/yarn/global/node_modules/.bin"; then
  export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
fi

macGPG="/usr/local/MacGPG2/bin"
if is_folder_exist "$macGPG"; then
  export PATH="$PATH:$macGPG"
fi

icu4c="/usr/local/opt/icu4c"
if is_folder_exist "$icu4c"; then
  export PATH="$PATH:${icu4c}/bin"
  export PATH="$PATH:${icu4c}/sbin"

  export PKG_CONFIG_PATH="${icu4c}/lib/pkgconfig"
fi

myzs_env="$MYZS_ROOT/.env"
if is_file_exist "$myzs_env"; then
  source "$myzs_env"
fi
