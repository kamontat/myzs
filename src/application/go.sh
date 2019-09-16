# shellcheck disable=SC1090,SC2148

export GOPATH="$HOME/Desktop/Personal/go"

if is_command_exist "go"; then
  export PATH="$PATH:$GOPATH/bin" # go lang
  export GO_ZSH_COMPLETE="$GOPATH/src/github.com/urfave/cli/autocomplete/zsh_autocomplete"
fi
