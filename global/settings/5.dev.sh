#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

# Are you developer?
export MYZS_IS_DEVELOPER=true

# Do you use 'git'
export MYZS_USE_GIT=true
# Do you use 'gitmoji'
export MYZS_USE_GITMOJI=true
# Do you use 'gitgo'
export MYZS_USE_GITGO=true
# Do you use 'node'
export MYZS_USE_NODE=true
export MYZS_USE_YARN=true
# Do you use 'java'
export MYZS_USE_JAVA=true
# Do you use 'android'
export MYZS_USE_ANDROID=true
# Do you use 'python'
export MYZS_USE_PYTHON=true
# Do you use 'ruby'
export MYZS_USE_RUBY=true
# Do you use 'docker'
export MYZS_USE_DOCKER=true
# Do you use 'iterm'
export MYZS_USE_ITERM=true
# Do you use 'zplug'
export MYZS_USE_ZPLUG=true
# Do you use which text-editor 'code|atom'
export MYZS_USE_EDITOR="code"

# FUNCTION SESSION
# BE AWARE

_myzs_print_silly_tofile "variable" "dev" "$MYZS_IS_DEVELOPER"
_myzs_print_silly_tofile "variable" "git" "$MYZS_USE_GIT"
_myzs_print_silly_tofile "variable" "gitmoji" "$MYZS_USE_GITMOJI"
_myzs_print_silly_tofile "variable" "gitgo" "$MYZS_USE_GITGO"
_myzs_print_silly_tofile "variable" "node" "$MYZS_USE_NODE"
_myzs_print_silly_tofile "variable" "yarn" "$MYZS_USE_YARN"
_myzs_print_silly_tofile "variable" "java" "$MYZS_USE_JAVA"
_myzs_print_silly_tofile "variable" "android" "$MYZS_USE_ANDROID"
_myzs_print_silly_tofile "variable" "python" "$MYZS_USE_PYTHON"
_myzs_print_silly_tofile "variable" "ruby" "$MYZS_USE_RUBY"
_myzs_print_silly_tofile "variable" "docker" "$MYZS_USE_DOCKER"
_myzs_print_silly_tofile "variable" "iterm" "$MYZS_USE_ITERM"
_myzs_print_silly_tofile "variable" "zplug" "$MYZS_USE_ZPLUG"
