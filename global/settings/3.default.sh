#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

export USER="kamontat"

# language
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export SHELL="/bin/zsh"

export EDITOR='nvim'
export VISUAL='code-insiders'

# FUNCTION SESSION
# BE AWARE

if_fully_debug_print "variable" "user: $USER"
if_fully_debug_print "variable" "lang, ctype, all: $LANG, $LC_CTYPE, $LC_ALL"
if_fully_debug_print "variable" "shell: $SHELL"
if_fully_debug_print "variable" "editor: $EDITOR"
if_fully_debug_print "variable" "visual: $VISUAL"
