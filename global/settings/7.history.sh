#!/usr/bin/env bash

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    28/04/2018

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

_myzs_print_silly_tofile "history" "filename" "$HISTFILE"
_myzs_print_silly_tofile "history" "size" "$HISTSIZE"
_myzs_print_silly_tofile "history" "save-size" "$SAVEHIST"
