# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "yarn"; then
  _myzs:internal:alias "y" "yarn"
  _myzs:internal:alias "yi" "yarn install"
  _myzs:internal:alias "ya" "yarn add"
  _myzs:internal:alias "yad" "yarn add --dev"

  _myzs:internal:alias "ys" "yarn start"
  _myzs:internal:alias "yc" "yarn compile"
  _myzs:internal:alias "yb" "yarn build"
  _myzs:internal:alias "yd" "yarn dev"
fi
