# shellcheck disable=SC1090,SC2148

######################################
# Zsh setting
# This is customize zsh setting.
# AUTO_OPEN_PATH will open new tab with current path.
#                This can use in macOS only
# RESET_ZGEN     will force zgen to reset initial command.
######################################
export AUTO_OPEN_PATH=true
export RESET_ZGEN=false
######################################

######################################
# Progress setting
# This contain the setting of progressbar.
# PG_SHOW_PERF_INFO will print the process with runtime
# PG_FORMAT_TIME    will format the time as mm:ss:ms
######################################
export PG_SHOW_PERF_INFO=true
export PG_FORMAT_TIME=true
######################################

######################################
# Available theme: default is spaceship
# https://mikebuss.com/2014/04/07/customizing-prezto/
# adam1         cloud         fire          oliver        pws           steeef
# adam2         damoekri      giddie        paradox       redhat        suse
# agnoster      default       kylewest      peepcode      restore       walters
# bart          elite         minimal       powerlevel9k  skwp          zefram
# bigfade       elite2        nicoulaj      powerline     smiley        sorin
# clint         fade          off           pure
######################################
export CUSTOM_THEME=true
export CUSTOM_THEME_URL=""
export CUSTOM_THEME_NAME="pure"
######################################
