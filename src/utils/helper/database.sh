# shellcheck disable=SC1090,SC2148

# We store data to variable, this will significant create a ton of variable

export __MYZS__DATABASE_PREFIX="__MYZS_DATABASE__"
export __MYZS__DATABASE_SETTER_PREFIX="_myzs:internal:db:setter"

_myzs:private:db:name() {
  local name="$1"
  echo "$name" |
    tr "/" "_" |
    tr "-" "_" |
    tr "[:lower:]" "[:upper:]" |
    tr -d "$" |
    tr -d "&" |
    tr -d "|" |
    tr -d ";" # remove $ & | ; <- to avoid injection
}

_myzs:internal:db:varname() {
  _myzs:private:db:name "${__MYZS__DATABASE_PREFIX}${1}-${2}"
}

_myzs:internal:db:setter:string() {
  local key="$1" name="$2" value="$3"
  local varname

  _myzs:internal:call log:debug "set $key $name='$value'"
  varname="$(_myzs:internal:db:varname "$key" "$name")"
  export "$varname=$value"
}

_myzs:internal:db:setter:array() {
  local key="$1" name="$2" varname value
  shift 2
  for data in "$@"; do
    if test -z "$value"; then
      value="\"$data\""
    else
      value="$value \"$data\""
    fi
  done

  _myzs:internal:call log:debug "set $key $name (array)"
  varname="$(_myzs:internal:db:varname "$key" "$name")"
  export "$varname=($value)"
}

_myzs:internal:db:setter:number() {
  _myzs:internal:db:setter:string "$1" "$2" "$3"
}

# Add data as true $1 setting name
_myzs:internal:db:setter:enabled() {
  _myzs:internal:db:setter:string "$1" "$2" "true"
}

# Add data as false $1 setting name
_myzs:internal:db:setter:disabled() {
  _myzs:internal:db:setter:string "$1" "$2" "false"
}

_myzs:internal:db:getter:string() {
  local key="$1" name="$2" fallback="$3" varname __vtest

  varname="$(_myzs:internal:db:varname "$key" "$name")"
  eval "__vtest=\"\${${varname}:-$fallback}\""
  echo "$__vtest"
}

_myzs:internal:db:getter:array() {
  local key="$1" name="$2" output="$3"

  varname="$(_myzs:internal:db:varname "$key" "$name")"
  eval "$output=(\${${variable}})"
}

_myzs:private:db:exec() {
  local cmd="$1" key="$2"
  shift 2

  "${__MYZS__DATABASE_SETTER_PREFIX}:${cmd}" "$key" "$@"
}

# store data in variable by input key
# $1 - data key
# $@ - data templates
# data template must start with "$" next is setter name and value
# e.g. _myzs:internal:db:loader "key" "$" "string" "data/example" "hello"
# result will be __MYZS_DATABASE__KEY_DATA_EXAMPLE="hello"
_myzs:internal:db:loader() {
  local key="$1" cmd="" args=()
  shift

  for data in "$@"; do
    if [[ "$data" == "$" ]]; then
      if [[ "${#args[@]}" -gt 0 ]]; then
        _myzs:private:db:exec "$cmd" "$key" "${args[@]}"

        cmd="" # reset data
        args=()
      fi
    else
      if test -z "$cmd"; then
        cmd="$data"
      else
        args+=("$data")
      fi
    fi
  done

  # for final command
  if [[ "${#args[@]}" -gt 0 ]]; then
    _myzs:private:db:exec "$cmd" "$key" "${args[@]}"
  fi
}

# support only string | number | boolean, but not array
_myzs:private:db:checker() {
  local cmd="$1" key="$2" name="$3" __vtest=""
  shift 3

  __vtest="$(_myzs:internal:db:getter:string "$key" "$name")"
  for matcher in "$@"; do
    if "$cmd" "$__vtest" "$matcher"; then
      return 0
    fi
  done

  return 1
}

# this can use in `_myzs:private:db:checker`
_myzs:private:db:checker:equals() {
  local actual="$1" expected="$2"
  [[ "$actual" == "$expected" ]]
}

# this can use in `_myzs:private:db:checker`
_myzs:private:db:checker:greater-than() {
  local actual="$1" expected="$2"
  [[ "$actual" -gt "$expected" ]]
}

# this can use in `_myzs:private:db:checker`
_myzs:private:db:checker:less-than() {
  local actual="$1" expected="$2"
  [[ "$actual" -lt "$expected" ]]
}

# this can use in `_myzs:private:db:checker`
_myzs:private:db:checker:contains() {
  local actual="$1" expected="$2"
  echo "$actual" | grep -iqF "$expected"
}

_myzs:internal:db:checker:string() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:equals "$@"
}

# use this when default value is disabled (false)
_myzs:internal:db:checker:enabled() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:equals "$1" "$2" "true" "TRUE" "True"
}

# use this when default value is enabled (true)
_myzs:internal:db:checker:disabled() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:equals "$1" "$2" "false" "FALSE" "False"
}

# $setting > $B && $setting > $C ...
_myzs:internal:db:checker:greater-than() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:greater-than "$@"
}

# $setting < $B && $setting < $C ...
_myzs:internal:db:checker:less-than() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:less-than "$@"
}

_myzs:internal:db:checker:contains() {
  _myzs:private:db:checker \
    _myzs:private:db:checker:contains "$@"
}
