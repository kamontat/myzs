# shellcheck disable=SC1090,SC2148

######################################
# Zsh setting
# This is customize zsh setting.
# RESET_ZGEN      will force zgen to reset initial command.
# AUTO_OPEN_PATH  will open new tab with current path.
#                 This can use in macOS only
# SHOW_TODO       will show the summary of todo.sh
#                 (work only if todo.sh is installed)
# WELCOME_MESSAGE welcome message when open new section
######################################
export RESET_ZGEN=false
export ZGEN_FORCE_SAVE=false
export AUTO_OPEN_PATH=true
export SHOW_TODO=false
export WELCOME_MESSAGE=""
######################################

######################################
# Progress setting
# This contain the setting of progressbar.
# PG_SHOW_PERF_INFO will print the process with runtime
# PG_FORMAT_TIME    will format the time as mm:ss:ms
######################################
export PG_SHOW_PERF_INFO=false
export PG_FORMAT_TIME=true
######################################

######################################
# Debugger setting
# This contain setting for debugging in case
# MYZS_LOG_FILE     is a log path pass empty string to disable log file
######################################
export MYZS_LOG_FILE="/tmp/myzs.log"
######################################

######################################
# Theme: (default is none)
# This is the setting about theme of zsh-prompt
# Available theme: https://mikebuss.com/2014/04/07/customizing-prezto
# adam1         cloud         fire          oliver        pws           steeef
# adam2         damoekri      giddie        paradox       redhat        suse
# agnoster      default       kylewest      peepcode      restore       walters
# bart          elite         minimal       powerlevel9k  skwp          zefram
# bigfade       elite2        nicoulaj      powerline     smiley        sorin
# clint         fade          off           pure
######################################
export THEME_NAME="pure"
######################################

######################################
# Information
# Update information of terminal environment
######################################
export MYZS_USER="kamontat"
######################################
