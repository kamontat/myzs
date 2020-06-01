# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if ! __myzs_is_plugin_installed "zsh-users/zsh-history-substring-search"; then
  __myzs_complete
fi

__myzs_info "update history search configuration"

bindkey '^[[A' history-substring-search-up
bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up

bindkey '^[[B' history-substring-search-down
bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
bindkey -M viins "$terminfo[kcud1]" history-substring-search-down

export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'
export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'
export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE='yes'
export HISTORY_SUBSTRING_SEARCH_FUZZY=''
