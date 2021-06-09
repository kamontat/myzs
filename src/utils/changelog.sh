# shellcheck disable=SC1090,SC2148

myzs:module:new "$0"

# $1 is command to run
#    fn arguments = "index" "version" "date" "description"
_myzs:internal:changelog:loop() {
  local cl="$_MYZS_ROOT/CHANGELOG.md"

  # changelogs array format
  # [ <version_number> <release_date> <description_per_line> ]
  local changelogs=()
  local descriptions=""
  local desc=""

  if _myzs:internal:checker:file-exist "$cl"; then
    # convert markdown to bash array
    while IFS= read -r line; do
      if [[ "$line" =~ "^##" ]]; then
        if _myzs:internal:checker:string-exist "$descriptions"; then
          changelogs+=("$descriptions")
          descriptions=""
        fi

        version="$(echo "$line" | grep -oE "[0-9].[0-9].[0-9](-(beta|alpha|rc)\.[0-9]+)? " | tr -d ' ')"
        datetime="$(echo "$line" | grep -oE "\([0-9]{1,2} [A-Z][a-z][a-z] [0-9]{4}\)" | tr -d '(' | tr -d ')')"

        changelogs+=("${version}" "${datetime}")

      elif [[ "$line" =~ "^-" ]]; then
        desc="$(echo "$line" | grep -oE "\- .+" | cut -c3-)"
        descriptions="${descriptions}\n${desc}"
      fi
    done <"$cl"

    # final check
    if _myzs:internal:checker:string-exist "$descriptions"; then
      changelogs+=("$descriptions")
      descriptions=""
    fi

    # execution
    local cmd="$1"
    local size="${#changelogs[@]}"

    local c=1
    for ((i = 1; i < size; i += 3)); do
      version="${changelogs[i]}"
      date="${changelogs[i + 1]}"
      description="${changelogs[i + 2]}"

      $cmd "$c" "$version" "$date" "$description"
      ((c++))
    done
  else
    _myzs:internal:log:error "changelog not found at $cl"
  fi
}
