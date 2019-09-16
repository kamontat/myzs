# shellcheck disable=SC1090,SC2148

# Globals for Lazy Loading
export LAZY_NAME=""
export LAZY_START_TIME=""

# Start Lazy Loading
lazy_start() {
  LAZY_NAME=$1
  LAZY_START_TIME=$(sec)

  "${MYZS_LIB}/revolver" -s 'bouncingBall' start "${GREEN}Lazy Loading ${YELLOW}${1}${GREEN}..."
}

# Stop Lazy Loading
lazy_stop() {
  TIME=$(($(sec) - $LAZY_START_TIME))

  "${MYZS_LIB}/revolver" stop

  echo "${GREEN}[+] Lazy Loaded ${YELLOW}${LAZY_NAME}${GREEN} in ${YELLOW}${TIME}${GREEN} ms." $(tput sgr0)
}

# Act as a stub to another shell function/command. When first run, it will load the actual function/command then execute it.
# E.g. This made my zsh load 0.8 seconds faster by loading `nvm` when "nvm", "npm" or "node" is used for the first time
# $1: space separated list of alias to release after the first load
# $2: file to source
# $3: name of the command to run after it's loaded
# $4+: argv to be passed to $3
function lazy_load() {
  local lazy_name=$1
  local load_func=$2
  shift 2

  local lazy_func="lazy_${load_func}"

  for i in "$@"; do
    # shellcheck disable=SC2139,SC2140
    alias "$i"="${lazy_func} ${i}"
  done

  # shellcheck disable=SC2145
  eval "
  function ${lazy_func}() {
    lazy_start '$lazy_name'
    unset -f ${lazy_func}
    lazy_load_clean $@
    eval ${load_func}
    unset -f ${load_func}
    lazy_stop
    eval \$@
  }
  "
}

function lazy_load_clean() {
  for i in "$@"; do
    unalias "$i"
  done
}
