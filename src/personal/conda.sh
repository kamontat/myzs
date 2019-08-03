# shellcheck disable=SC1090,SC2148

# added by Miniconda3 installer
export PATH="/Users/kamontat/miniconda3/bin:$PATH"

# test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
# added by Miniconda3 4.5.12 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$(CONDA_REPORT_ERRORS=false '/Users/kamontat/miniconda3/bin/conda' shell.bash hook 2>/dev/null)"
if [ $? -eq 0 ]; then
  \eval "$__conda_setup"
else
  if [ -f "/Users/kamontat/miniconda3/etc/profile.d/conda.sh" ]; then
    . "/Users/kamontat/miniconda3/etc/profile.d/conda.sh"
    CONDA_CHANGEPS1=false conda activate base
  else
    \export PATH="/Users/kamontat/miniconda3/bin:$PATH"
  fi
fi
unset __conda_setup
# <<< conda init <<<
