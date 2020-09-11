# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "docker"; then
  _myzs:internal:alias "dps" "docker ps"
  _myzs:internal:alias "dlog" "docker logs"

  _myzs:internal:alias "drm" "docker rm"
  _myzs:internal:alias "drm-all" "docker rm $(docker ps -aq)"

  _myzs:internal:alias "di" "docker images"
  _myzs:internal:alias "drmi" "docker rmi"
  _myzs:internal:alias "drmi-all" "docker rmi $(docker images -aq)"

  _myzs:internal:alias "dhi" "docker history"
fi

if _myzs:internal:checker:command-exist "docker-compose"; then
  _myzs:internal:alias "dcb" "docker-compose build"
  _myzs:internal:alias "dce" "docker-compose exec"
  _myzs:internal:alias "dcps" "docker-compose ps"
  _myzs:internal:alias "dcrestart" "docker-compose restart"
  _myzs:internal:alias "dcrm" "docker-compose rm"
  _myzs:internal:alias "dcr" "docker-compose run"
  _myzs:internal:alias "dcstop" "docker-compose stop"
  _myzs:internal:alias "dcup" "docker-compose up"
  _myzs:internal:alias "dcud" "docker-compose up -d"
  _myzs:internal:alias "dcdn" "docker-compose down"
fi
