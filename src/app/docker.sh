# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export DOCKER_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker"
export DOCKER_COMPOSE_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker-compose"

if ! _myzs:internal:checker:file-exist "$DOCKER_COMPLETION"; then
  cp "${__MYZS__RES}/_docker" "$DOCKER_COMPLETION"
fi

if ! _myzs:internal:checker:file-exist "$DOCKER_COMPOSE_COMPLETION"; then
  cp "${__MYZS__RES}/_docker-compose" "$DOCKER_COMPOSE_COMPLETION"
fi
