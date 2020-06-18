# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

__agoda_kube() {
  confpath="${1:-$HOME/.kube/config}"
  namespace="${2:-pricepush-ci1}"

  docker \
    run \
    --rm \
    -it \
    -e TILLER_NAMESPACE="$namespace" \
    -v "$HOME/Desktop/docker:/root/workspace" \
    -v "${confpath}:/root/.kube/config" \
    -w /root/workspace \
    "reg-hk.agodadev.io/aiab/kubectl-helm:hkci-helm3" \
    /bin/bash
}

__myzs_alias "agkube" "__agoda_kube"
