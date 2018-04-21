#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

# Open debug mode will log almost every action in the script
# 1. none  - never log or print everything
# 2. debug - print loading result only
# 3. file  - log output to log file only
# 4. full  - print and log everything
export MYZS_DEBUG_MODE="file" # none|debug|file|full

# FUNCTION SESSION
# BE AWARE

if_fully_debug_print "variable" "debug: $MYZS_DEBUG_MODE"
