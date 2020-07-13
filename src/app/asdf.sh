# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "asdf"; then
  __myzs_asdf_is_set() {
    asdf current "$1" >/dev/null
  }

  ASDF_HOME="$(brew --prefix asdf)"
  export ASDF_HOME

  # Install via Homebrew
  __myzs_load "ASDF setup script" "$ASDF_HOME/asdf.sh"
  # __myzs_load "ASDF completion script" "$ASDF_HOME/etc/bash_completion.d/asdf.bash"

  if __myzs_asdf_is_set java; then
    asdf_update_java_home() {
      local java_path
      java_path="$(asdf which java)"
      if [[ -n "${java_path}" ]]; then
        export JAVA_HOME
        JAVA_HOME="$(dirname "$(dirname "$(realpath "${java_path}")")")"
      fi
    }

    autoload -U add-zsh-hook
    add-zsh-hook precmd asdf_update_java_home
  fi
else
  __myzs_failure
fi
