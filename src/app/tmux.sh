# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

tmux-start-servers() {
  local hosts=("${HOSTS[@]:-$@}")
  if test -z "${hosts[*]}"; then
    echo -n "Please provide of list of hosts separated by spaces [ENTER]: "
    read -ra hosts
  fi

  for i in "${hosts[@]}"; do
    echo "start $i"
  done

  local first_host="${hosts[0]}"

  tmux new-window "ssh $first_host"
  unset 'hosts[0]'
  for i in "${hosts[@]}"; do
    tmux split-window -h "ssh $i"
    tmux select-layout tiled >/dev/null
  done
  tmux select-pane -t 0
  tmux set-window-option synchronize-panes on >/dev/null
}
