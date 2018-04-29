#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

export MYZS_WORK_ROOT="${HOME}/Desktop"

export MYZS_WORKSPACE_DIRNAME="Workspaces" # place of work
export MYZS_PROJECT_DIRNAME="Projects"     # place of play
export MYZS_LAB_DIRNAME="Labs"             # place of test
export MYZS_LIBRARY_DIRNAME=""             # place of library

# FUNCTION SESSION
# BE AWARE
_myzs_print_silly_tofile "location" "root" "$MYZS_WORK_ROOT"
_myzs_print_silly_tofile "location" "workspace" "$MYZS_WORKSPACE_DIRNAME"
_myzs_print_silly_tofile "location" "project" "$MYZS_PROJECT_DIRNAME"
_myzs_print_silly_tofile "location" "lab" "$MYZS_LAB_DIRNAME"
_myzs_print_silly_tofile "location" "library" "$MYZS_LIBRARY_DIRNAME"
