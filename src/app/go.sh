# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

# $HOME/go is default go path in macos
export GOPATH="${__GOPATH:-$HOME/go}"

if _myzs:internal:checker:command-exist "go"; then
  _myzs:internal:path-append "$GOPATH/bin"

  _myzs:internal:fpath-push "$GOPATH/src/github.com/urfave/cli/autocomplete/zsh_autocomplete"
fi
