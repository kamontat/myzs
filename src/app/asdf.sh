# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export ASDF_HOME="$(brew --prefix asdf)"

# Install via Homebrew
__myzs_load "ASDF setup script" "$ASDF_HOME/asdf.sh"
__myzs_load "ASDF completion script" "$ASDF_HOME/etc/bash_completion.d/asdf.bash"
