# shellcheck disable=SC1090,SC2148

export ASDF_HOME="$(brew --prefix asdf)"

# Install via Homebrew
source_file "$ASDF_HOME/asdf.sh"
source_file "$ASDF_HOME/etc/bash_completion.d/asdf.bash"
