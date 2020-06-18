# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

export GOPATH="${__GOPATH:-$HOME/Desktop/Personal/go}"

if __myzs_is_command_exist "go"; then
  __myzs_append_path "$GOPATH/bin"

  __myzs_fpath "$GOPATH/src/github.com/urfave/cli/autocomplete/zsh_autocomplete"
fi
