# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "yarn"; then
  __myzs_alias "y" "yarn"
  __myzs_alias "yi" "yarn install"
  __myzs_alias "ya" "yarn add"
  __myzs_alias "yad" "yarn add --dev"

  __myzs_alias "ys" "yarn start"
  __myzs_alias "yc" "yarn compile"
  __myzs_alias "yb" "yarn build"
  __myzs_alias "yd" "yarn dev"
fi
