# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

__agoda_kube() {
  confpath="${1:-$HOME/.kube/config}"
  namespace="${2:-pricepush-ci1}"
  workspace="${3:-$HOME/Desktop/docker}"

  docker \
    run \
    --rm \
    -it \
    -e TILLER_NAMESPACE="$namespace" \
    -v "${workspace}:/root/workspace" \
    -v "${confpath}:/root/.kube/config" \
    -w /root/workspace \
    "reg-hk.agodadev.io/aiab/kubectl-helm:hkci-helm3" \
    /bin/bash
}
__myzs_alias "agkube" "__agoda_kube"

if __myzs_shell_is_zsh; then
  __agoda_ssh() {
    local name="$1"
    local start="$2"
    local end="$3"

    # shellcheck disable=SC2051,SC2086,SC2207
    arr=($(echo "$name"{$start..$end}))
    if __myzs_is_command_exist "tmux-start-servers"; then
      tmux-start-servers "${arr[@]}"
    else
      echo "cannot found 'tmux-start-servers' command"
    fi

  }
  __myzs_alias "agssh" "__agoda_ssh"
fi
