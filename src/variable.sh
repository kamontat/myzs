# shellcheck disable=SC1090,SC2148

export SHELL="/usr/local/bin/zsh"
# chsh -s "$SHELL"

export PATH="/bin"                  # bin
export PATH="/sbin:$PATH"           # sbin

export PATH="/usr/bin:$PATH"        # user bin
export PATH="/usr/sbin:$PATH"       # user sbin

export PATH="/usr/local/bin:$PATH"  # local user bin
export PATH="/usr/local/sbin:$PATH" # local user sbin

export ARCHFLAGS="-arch x86_64"

# language
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"