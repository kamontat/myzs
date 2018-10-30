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
export PG_SHOW_PERF_INFO=false
export PG_FORMAT_TIME=true
######################################

######################################
# Theme: (default is none)
# This is the setting about theme of zsh-prompt
# There are multiple way to setting:
# | CUSTOM | URL            | NAME     | Result                             |
# |----- --|----------------|----------|------------------------------------|
# | false  | "" or "<link>" | ""       | None theme will be used            |
# | false  | "" or "<link>" | "<name>" | Available theme will be used       |
# | true   | "<link>"       | "<name>" | Custom theme from git will be used |
# |--------|----------------|----------|------------------------------------|
# Otherwise, none of theme will be used
# Available theme: https://mikebuss.com/2014/04/07/customizing-prezto
# adam1         cloud         fire          oliver        pws           steeef
# adam2         damoekri      giddie        paradox       redhat        suse
# agnoster      default       kylewest      peepcode      restore       walters
# bart          elite         minimal       powerlevel9k  skwp          zefram
# bigfade       elite2        nicoulaj      powerline     smiley        sorin
# clint         fade          off           pure
######################################
export CUSTOM_THEME=false
export CUSTOM_THEME_URL=""        # https://github.com/denysdovhan/spaceship-prompt.git
export CUSTOM_THEME_NAME="steeef" # spaceship
######################################

######################################
# Information
# Update information of terminal environment
######################################
export MYZS_USER="kamontat"
######################################