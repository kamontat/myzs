# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

export DOCKER_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker"
export DOCKER_COMPOSE_COMPLETION="$HOME/.myzs/zplug/repos/zsh-users/zsh-completions/src/_docker-compose"

if ! __myzs_is_file_exist "$DOCKER_COMPLETION"; then
  cp "${__MYZS_RESOURCES}/_docker" "$DOCKER_COMPLETION"
fi

if ! __myzs_is_file_exist "$DOCKER_COMPOSE_COMPLETION"; then
  cp "${__MYZS_RESOURCES}/_docker-compose" "$DOCKER_COMPOSE_COMPLETION"
fi
