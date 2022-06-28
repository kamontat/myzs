# shellcheck disable=SC2148

# Summary: Variable is faster than array

# Variable Statistics:
# real  0m3.130s
# user  0m2.326s
# sys   0m0.554s
# bash  ./perf/variable-vs-array.sh var  2.33s user 0.56s system 91% cpu 3.136 totalห

# Array Statistics:
# real  0m3.536s
# user  0m2.712s
# sys   0m0.572s
# bash  ./perf/variable-vs-array.sh  2.71s user 0.57s system 92% cpu 3.543 total

# zmodload zsh/zprof # enable profiling

export __test_run_iteration=5000

export __test_array=(
  "jtnzs#zciyiobcb9il8xs" "ifht#dd7aryi"
  "zijdgdz#w5eb4"
  "clcdbm#7y7ugkjce0m9y697z7zh"
  "fsm#sxiqkjlnuacd"
  "skkjydo#ws0e2cn1mto83xo9gji5"
  "fpzomzcf#z21pk0hfmokt5m"
  "jjcbvo#7qw5yct3zzpsz623x06u"
  "rntiwl#080eu51oa3hwhf"
  "imugb#zg5y775d3y7q7ro"
  "ddsypc#qpwmjrq"
  "abg#vu8c0"
  "any#7amt759s13"
  "hdml#n9urv4qanorm"
  "votht#6j07okksg25oqb4"
  "ocns#a1i24g74"
  "iyrugvzg#pugt8trgpa5xpa53l"
  "zicda#09b6onlnugrkl64"
  "bgl#dlnbxcc7dugrau8"
  "scbhie#f5e2cdz9ey8z145"
)

export _test_array
_test_array() {
  local _index _key _value _array=()
  for ((n = 0; n < __test_run_iteration; n++)); do
    _index=0
    for _input in "${__test_array[@]}"; do
      _key="${_input%%"#"*}" _value="${_input##*"#"}"
      _array+=("$_value")
      # echo "${_array[@]}"
      eval "echo \"\${_array[$_index]}\""
      _index=$((_index + 1))
    done
  done
}

export _test_variable
_test_variable() {
  local _key _value _array
  for ((n = 0; n < __test_run_iteration; n++)); do
    for _input in "${__test_array[@]}"; do
      _key="${_input%%"#"*}" _value="${_input##*"#"}"
      export "$_key=$_value"
      eval "echo \"\$$_key\""
    done
  done
}

if [[ "$1" == "var" ]]; then
  echo "test variable mode"
  time (
    _test_variable
  )
else
  echo "test array mode"
  time (
    _test_array
  )
fi

# When enabled profiling
# zprof
