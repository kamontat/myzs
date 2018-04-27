#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.1.0
# since:    21/04/2018

# Do you use 'wakatime'
export MYZS_USE_WAKA=true

# Do you use 'utils pack'
# 1. 'wd' -> jump to point directory
# 2. 'calc' -> simple zsh calculator
# 3. 'fasd' -> offers quick access to files and directories (DISABLE)
# 4. 'web-search' -> searching thing in internet, exp: 'google hello'
export MYZS_USE_UTIL=true

# auto correct wrong command
export MYZS_USE_CORRECTION=true

# zplug home, comment if you don't use
export ZPLUG_HOME=/usr/local/opt/zplug

# FUNCTION SESSION
# BE AWARE

_myzs_if_fully_debug_print "variable" "waka: $MYZS_USE_WAKA"
_myzs_if_fully_debug_print "variable" "utils: $MYZS_USE_UTIL"
_myzs_if_fully_debug_print "variable" "correction: $MYZS_USE_CORRECTION"
_myzs_if_fully_debug_print "variable" "zplug: $ZPLUG_HOME"
