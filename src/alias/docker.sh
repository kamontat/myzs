# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

if __myzs_is_command_exist "docker"; then
  __myzs_alias "dps" "docker ps"
  __myzs_alias "dlog" "docker logs"

  __myzs_alias "drm" "docker rm"
  __myzs_alias "drm-all" "docker rm $(docker ps -aq)"

  __myzs_alias "di" "docker images"
  __myzs_alias "drmi" "docker rmi"
  __myzs_alias "drmi-all" "docker rmi $(docker images -aq)"

  __myzs_alias "dhi" "docker history"
fi

if __myzs_is_command_exist "docker-compose"; then
  __myzs_alias "dcb" "docker-compose build"
  __myzs_alias "dce" "docker-compose exec"
  __myzs_alias "dcps" "docker-compose ps"
  __myzs_alias "dcrestart" "docker-compose restart"
  __myzs_alias "dcrm" "docker-compose rm"
  __myzs_alias "dcr" "docker-compose run"
  __myzs_alias "dcstop" "docker-compose stop"
  __myzs_alias "dcup" "docker-compose up"
  __myzs_alias "dcud" "docker-compose up -d"
  __myzs_alias "dcdn" "docker-compose down"
fi
