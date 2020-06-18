# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

export DEFAULT_USER="$USER"

export SHELL_FILE="${SHELL_FILE:-/etc/shells}"
export DEFAULT_SHELL="${SHELL:-/bin/zsh}"

export PATH="/bin"        # bin
export PATH="/sbin:$PATH" # sbin

export PATH="/usr/bin:$PATH"  # user bin
export PATH="/usr/sbin:$PATH" # user sbin

export PATH="/usr/local/bin:$PATH"  # local user bin
export PATH="/usr/local/sbin:$PATH" # local user sbin

export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

export MANPATH="/usr/local/man:$MANPATH"

if __myzs_is_file_exist "$SHELL_FILE"; then
  if ! __myzs_is_file_contains "$SHELL_FILE" "$DEFAULT_SHELL"; then
    __myzs_info "adding $DEFAULT_SHELL to shell file ($SHELL_FILE)"
    echo "$DEFAULT_SHELL" | sudo tee -a "$SHELL_FILE" >/dev/null
  fi

  if [[ "$DEFAULT_SHELL" != "$SHELL" ]]; then
    __myzs_warn "current shell is $SHELL but it should be $DEFAULT_SHELL"
    chsh -s "$DEFAULT_SHELL"
  fi
fi

if __myzs_is_command_exist "nvim"; then
  nvim_path="$(command -v nvim)"
  export GIT_EDITOR="$nvim_path"
  export VISUAL="$nvim_path"
  export EDITOR="$nvim_path"
else
  vim_path="$(command -v vim)"
  export GIT_EDITOR="$vim_path"
  export VISUAL="$vim_path"
  export EDITOR="$vim_path"
fi
