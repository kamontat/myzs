#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

export MYZS_WORK_ROOT="${HOME}/Desktop"

export MYZS_WORKSPACE_DIRNAME="Workspaces" # place of work
export MYZS_PROJECT_DIRNAME="Projects"     # place of play
export MYZS_LAB_DIRNAME="Labs"             # place of test
# export MYZS_LIBRARY_DIRNAME="Libraries" # place of library

# FUNCTION SESSION
# BE AWARE

_myzs_if_fully_debug_print "variable" "world location: $MYZS_WORK_ROOT"
_myzs_if_fully_debug_print "variable" "workspace name: $MYZS_WORKSPACE_DIRNAME"
_myzs_if_fully_debug_print "variable" "project name: $MYZS_PROJECT_DIRNAME"
_myzs_if_fully_debug_print "variable" "lab name: $MYZS_LAB_DIRNAME"
_myzs_if_fully_debug_print "variable" "library name: $MYZS_LIBRARY_DIRNAME"
