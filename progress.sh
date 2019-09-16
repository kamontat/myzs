#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by v3.0.2
# link (https://github.com/Template-generator/script-genrating/tree/v3.0.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

#/ -----------------------------------
#/ Description:  Add progressbar method
#/ -----------------------------------
#/ Create by:    Kamontat Chantrachirathunrong <kamontat.c@hotmail.com>
#/ Since:        02/09/2018
#/ -----------------------------------

# 1. func -> execute function
# 2. name -> name of this execution
# n. value for each execution
progressbar() {
  local cmd="$1"
  local title="$2"
  shift 2
  IFS=" " read -r -a array <<<"$@"
  duration=$#

  curr_bar=0
  for ((elapsed = 1; elapsed <= duration; elapsed++)); do
    barsize=$(($(tput cols) - 25))
    unity=$((barsize / duration))
    increment=$((barsize % duration))
    skip=$((duration / (duration - increment)))
    # Elapsed
    ((curr_bar += unity))

    if [[ $increment -ne 0 ]]; then
      if [[ $skip -eq 1 ]]; then
        [[ $((elapsed % (duration / increment))) -eq 0 ]] && ((curr_bar++))
      else
        [[ $((elapsed % skip)) -ne 0 ]] && ((curr_bar++))
      fi
    fi

    [[ $elapsed -eq 1 && $increment -eq 1 && $skip -ne 1 ]] && ((curr_bar++))
    [[ $((barsize - curr_bar)) -eq 1 ]] && ((curr_bar++))
    [[ $curr_bar -lt $barsize ]] || curr_bar=$barsize

    printf "%-15s |" "$title"

    # Exection
    "$cmd" "${array[elapsed - 1]}"

    # Progress
    for ((filled = 0; filled <= curr_bar; filled++)); do
      printf "#"
    done

    # Remaining
    for ((remain = curr_bar; remain < barsize; remain++)); do
      printf " "
    done

    # Percentage
    printf "| %s%%" $(((elapsed * 100) / duration))

    # Return
    printf '\r'
  done
  echo
}
