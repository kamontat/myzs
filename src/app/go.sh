# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export GOPATH="${__GOPATH:-$HOME/Desktop/Personal/go}"

if __myzs_is_command_exist "go"; then
  __myzs_push_path "$GOPATH/bin"

  __myzs_fpath "$GOPATH/src/github.com/urfave/cli/autocomplete/zsh_autocomplete"
fi
