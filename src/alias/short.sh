# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

_myzs:internal:alias "c" "clear"

if _myzs:internal:checker:command-exist "k"; then
  _myzs:internal:alias "l" "k"
  # _myzs:internal:alias "ls" "k"
  _myzs:internal:alias "la" "k"
else
  _myzs:internal:alias "l" "ls"
  _myzs:internal:alias "la" 'ls --almost-all --no-group --human-readable --sort=time --format=verbose --time-style="+%d/%m/%Y-%H:%M:%S"'
fi

_myzs:internal:alias "s" "source"

_myzs:internal:alias "rmf" "rm -rf"

_myzs:internal:alias "srm" "sudo rm -rf"
_myzs:internal:alias "smkdir" "sudo mkdir"
_myzs:internal:alias "stouch" "sudo touch"

_myzs:internal:alias "allhistory" "fc -El 1"
_myzs:internal:alias "history-stat" "history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

_myzs:internal:alias "copy-path" "pwd | pbcopy"

if _myzs:internal:checker:command-exist "tmux"; then
  _myzs:internal:alias "t" "tmux"
fi
