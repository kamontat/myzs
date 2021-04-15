# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

export SHELL_FILE="${SHELL_FILE:-/etc/shells}"
export MYZS_DEFAULT_SHELL="${MYZS_DEFAULT_SHELL:-$SHELL}"

export PATH="/bin"        # bin
export PATH="/sbin:$PATH" # sbin

export PATH="/usr/bin:$PATH"  # user bin
export PATH="/usr/sbin:$PATH" # user sbin

export PATH="/usr/local/bin:$PATH"  # local user bin
export PATH="/usr/local/sbin:$PATH" # local user sbin

export LANG="${LANG:-en_US.UTF-8}"
export LC_CTYPE="${LC_CTYPE:-en_US.UTF-8}"
export LC_ALL="${LC_ALL:-en_US.UTF-8}"

export MANPATH
if _myzs:internal:checker:mac; then
  MANPATH="$(manpath -w)"
else
  MANPATH="$(manpath -g)"
fi

if _myzs:internal:checker:file-exist "$SHELL_FILE"; then
  if ! _myzs:internal:checker:file-contains "$SHELL_FILE" "$MYZS_DEFAULT_SHELL"; then
    _myzs:internal:log:info "adding $MYZS_DEFAULT_SHELL to shell file ($SHELL_FILE)"
    echo "$MYZS_DEFAULT_SHELL" | sudo tee -a "$SHELL_FILE" >/dev/null
  fi

  if [[ "$MYZS_DEFAULT_SHELL" != "$SHELL" ]]; then
    _myzs:internal:log:warn "current shell is $SHELL but it should be $MYZS_DEFAULT_SHELL"
    chsh -s "$MYZS_DEFAULT_SHELL"
  fi
fi

if _myzs:internal:checker:command-exist "nvim"; then
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
