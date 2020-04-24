# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

__myzs_alias "c" "clear"

if __myzs_is_command_exist "k"; then
  __myzs_alias "l" "k"
  # __myzs_alias "ls" "k"
  __myzs_alias "la" "k"
else
  __myzs_alias "l" "ls"
  __myzs_alias "la" 'ls --almost-all --no-group --human-readable --sort=time --format=verbose --time-style="+%d/%m/%Y-%H:%M:%S"'
fi

__myzs_alias "s" "source"

__myzs_alias "rmf" "rm -rf"

__myzs_alias "srm" "sudo rm -rf"
__myzs_alias "smkdir" "sudo mkdir"
__myzs_alias "stouch" "sudo touch"

__myzs_alias "allhistory" "fc -El 1"
__myzs_alias "history-stat" "history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

__myzs_alias "copy-path" "pwd | pbcopy"

if __myzs_is_command_exist "tmux"; then
  __myzs_alias "t" "tmux"
fi
