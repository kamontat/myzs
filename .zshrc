# shellcheck disable=SC1090,SC2148

# set -x # enable DEBUG MODE

##############################
# Application settings       #
##############################

# Enable debug mode;
# export MYZS_DEBUG=true

# custom user variable
# export MYZS_USER="kamontat"

export MYZS_SETTINGS_AUTO_OPEN_PATH=true
# export MYZS_SETTINGS_WELCOME_MESSAGE="hello, world"

export MYZS_TYPE="FULLY" # either FULLY | SMALL

export MYZS_ROOT=$HOME/.myzs

##############################
# Dependenies settings       #
##############################

export PG_SHOW_PERF=true

export ZPLUG_HOME="${MYZS_ROOT}/zplug"

##############################
# Shell environment variable #
##############################

export SHELL="/usr/local/bin/zsh"

if test -f "${MYZS_ROOT}/init.sh"; then
  source "${MYZS_ROOT}/init.sh"
fi

# ###-begin-pm2-completion-###
# ### credits to npm for the completion file model
# #
# # Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
# #

# COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
# COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
# export COMP_WORDBREAKS

# if type complete &>/dev/null; then
#   _pm2_completion () {
#     local si="$IFS"
#     IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
#                            COMP_LINE="$COMP_LINE" \
#                            COMP_POINT="$COMP_POINT" \
#                            pm2 completion -- "${COMP_WORDS[@]}" \
#                            2>/dev/null)) || return $?

#     IFS="$si"
#   }
#   complete -o default -F _pm2_completion pm2
# elif type compctl &>/dev/null; then
#   _pm2_completion () {
#     local cword line point words si
#     read -Ac words
#     read -cn cword
#     let cword-=1
#     read -l line
#     read -ln point
#     si="$IFS"
#     IFS=$'\n' reply=($(COMP_CWORD="$cword" \
#                        COMP_LINE="$line" \
#                        COMP_POINT="$point" \
#                        pm2 completion -- "${words[@]}" \
#                        2>/dev/null)) || return $?

#     IFS="$si"
#   }
#   compctl -K _pm2_completion + -f + pm2
# fi
# ###-end-pm2-completion-###
