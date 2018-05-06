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

export VISUAL='nvim'
export EDITOR='code-insiders'

# FUNCTION SESSION
# BE AWARE
_myzs_print_silly_tofile "variable" "user" "$USER"
_myzs_print_silly_tofile "variable" "lang" "$LANG"
_myzs_print_silly_tofile "variable" "lcctype" "$LC_CTYPE"
_myzs_print_silly_tofile "variable" "lcall" "$LC_ALL"
_myzs_print_silly_tofile "variable" "shell" "$SHELL"
_myzs_print_silly_tofile "variable" "editor" "$EDITOR"
_myzs_print_silly_tofile "variable" "visual" "$VISUAL"
