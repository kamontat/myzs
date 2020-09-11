# shellcheck disable=SC1090,SC2148

default_kube_config="$HOME/.kube/config"
if _myzs:internal:checker:string-exist "$KUBECONFIG"; then
  export KUBECONFIG="$KUBECONFIG:${default_kube_config}"
else
  export KUBECONFIG="${default_kube_config}"
fi

unset default_kube_config
