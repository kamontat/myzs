# shellcheck disable=SC1090,SC2148

export USER="$MYZS_USER"
export DEFAULT_USER="$USER"

export GOPATH="$HOME/Desktop/Projects/go"

# if is_command_exist "go"; then
export PATH="$GOPATH/bin:$PATH" # go lang
export GO_ZSH_COMPLETE="$GOPATH/src/github.com/urfave/cli/autocomplete/zsh_autocomplete"
# fi
