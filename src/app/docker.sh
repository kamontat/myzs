# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

export DOCKER_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker"
export DOCKER_COMPOSE_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker-compose"

if ! __myzs_is_file_exist "$DOCKER_COMPLETION"; then
  cp "${__MYZS_RESOURCES}/_docker" "$DOCKER_COMPLETION"
fi

if ! __myzs_is_file_exist "$DOCKER_COMPOSE_COMPLETION"; then
  cp "${__MYZS_RESOURCES}/_docker-compose" "$DOCKER_COMPOSE_COMPLETION"
fi
