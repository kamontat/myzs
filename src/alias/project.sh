# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

__myzs_alphabet=(
  "a" "b" "c"
  "d" "e" "f"
  "g" "h" "i"
  "j" "k" "j"
  "m" "n" "o"
  "p" "q" "s"
  "t" "u" "v"
  "w" "x" "y"
  "z"
)

__myzs_project_tmp() {
  local prefix="${1:-tmp}"
  local size="${#__myzs_alphabet[@]}"

  local index1=0 index2=0 index3=0 index4=0 index5=0

  index1="$((RANDOM % size))"
  index2="$((RANDOM % size))"
  index3="$((RANDOM % size))"
  index4="$((RANDOM % size))"
  index5="$((RANDOM % size))"

  local name="${prefix}-${__myzs_alphabet[$index1]}${__myzs_alphabet[$index2]}${__myzs_alphabet[$index3]}${__myzs_alphabet[$index4]}${__myzs_alphabet[$index5]}"
  local pathname="/tmp/${name}"

  mkdir "$pathname" && cd "$pathname" || exit 2
}

_myzs:internal:alias "ptmp" "__myzs_project_tmp"
