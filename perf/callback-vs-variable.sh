# shellcheck disable=SC2148

# Summary: Callback is faster than variable

# Variable Statistics:
# real  0m1.654s
# user  0m1.515s
# sys   0m0.105s
# bash  ./perf/callback-vs-variable.sh var  1.52s user 0.11s system 97% cpu 1.660 total

# Callback Statistics:
# real  0m1.480s
# user  0m1.356s
# sys   0m0.097s
# bash  ./perf/callback-vs-variable.sh  1.36s user 0.10s system 97% cpu 1.489 total


# zmodload zsh/zprof # enable profiling

export __test_run_iteration=500

export __test_array=(
  "a/test#1" "b/hello#2" "c/world#3" "d/single#4" "e/unit#5" "f/user#6"
  "g/name#7" "h/page#8" "i/age#9" "j/number#10" "k/zplug#11" "l/table#12"
  "m/display#13" "n/random#14" "o/understand#15" "p/dell#16" "q/com#17"
  "r/phone#18" "s/developer#19" "t/quite#20" "u/only#21" "v/help#22"
  "w/ant#23" "x/because#24" "y/use#25" "z/store#26" "aa/pool#27" "ab/owl#28"
  "ac/extra#29" "ad/able#30"
)

# export _output=()

__test_parse_callback() {
  local _input="$1" separator="$2" _cmd="$3"
  shift 3

  local _index="${_input##*"$separator"}" _value="${_input%%"$separator"*}"
  $_cmd "$_index" "$_value" "$@"
}

__test_parse_variable() {
  local _input="$1" separator="$2"
  shift 2

  local _index="${_input##*"$separator"}" _value="${_input%%"$separator"*}"
  export _TEST_INDEX="$_index"
  export _TEST_VALUE="$_value"
  export _TEST_ARGUMENTS=("$@")
}

__test_execution() {
  echo "$3: $1-$2"
}

__test_callback() {
  local index="$1" value="$2"
  __test_parse_callback "$value" "/" "__test_execution" "$index"
}

export _test_callback
_test_callback() {
  for ((n = 0; n < __test_run_iteration; n++)); do
    for i in "${__test_array[@]}"; do
      __test_parse_callback "$i" "#" "__test_callback"
    done
  done
}

export _test_variable
_test_variable() {
  local id ns v
  for ((n = 0; n < __test_run_iteration; n++)); do
    for i in "${__test_array[@]}"; do
      __test_parse_variable "$i" "#"
      id="$_TEST_INDEX"

      __test_parse_variable "$_TEST_VALUE" "/"
      ns="$_TEST_INDEX"
      v="$_TEST_VALUE"

      __test_execution "$ns" "$v" "$id"
    done
  done
}

if [[ "$1" == "var" ]]; then
  echo "test variable mode"
  time (
    _test_variable
  )
else
  echo "test callback mode"
  time (
    _test_callback
  )
fi

# When enabled profiling
# zprof
