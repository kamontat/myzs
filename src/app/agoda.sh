# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

__myzs__agoda_kube() {
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
_myzs:internal:alias "agkube" "__myzs__agoda_kube"

__myzs__agoda_docker_run_consul() {
  docker run --rm -it -p 8500:8500 consul:latest
}
_myzs:internal:alias "agrun-consul" "__myzs__agoda_docker_run_consul"

__myzs__agoda_docker_run() {
  local default_image="$1"
  local image="${2:-$default_image}"

  [[ $image == "default" ]] && image="$default_image"
  shift 2

  local arguments=("$@")

  echo "exec: docker pull ${image}"
  echo "exec: docker run --rm -it ${arguments[*]} ${image}"
  docker run --rm -it "${arguments[@]}" "${image}"
}

__myzs__agoda_docker_run_cdb() {
  local default_image="reg-hk.agodadev.io/dbdev/qa_sql_cdb_data_hotel-list-affiliate"
  local image="${1}"
  shift 1

  __myzs__agoda_docker_run "${default_image}" "$image" -p "1433:1433" "$@"
}
_myzs:internal:alias "agrun-cdb" "__myzs__agoda_docker_run_cdb"

__myzs__agoda_docker_run_mdb() {
  local default_image="reg-hk.agodadev.io/dbdev/qa_sql_mdb_schema_nodata"
  local image="${1}"
  shift 1

  __myzs__agoda_docker_run "${default_image}" "$image" -p "1433:1433" "$@"
}
_myzs:internal:alias "agrun-mdb" "__myzs__agoda_docker_run_mdb"

if _myzs:internal:checker:shell:zsh; then
  __agoda_ssh() {
    local name="$1"
    local start="$2"
    local end="$3"

    # shellcheck disable=SC2051,SC2086,SC2207
    arr=($(echo "$name"{$start..$end}))
    if _myzs:internal:checker:command-exist "tmux-start-servers"; then
      tmux-start-servers "${arr[@]}"
    else
      echo "cannot found 'tmux-start-servers' command"
    fi

  }
  _myzs:internal:alias "agssh" "__agoda_ssh"
fi
