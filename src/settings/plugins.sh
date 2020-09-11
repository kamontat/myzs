# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

myzs:zplug:initial-plugins() {
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'

  if _myzs:internal:checker:command-exist "myzs:zplug:plugin-list"; then
    myzs:zplug:plugin-list
  else
    # Require libraries
    zplug "mafredri/zsh-async", from:github, use:"async.zsh"

    # zplug "b4b4r07/httpstat", as:command, use:'(*).sh', rename-to:'$1' # like curl -v
    # zplug "stedolan/jq", from:gh-r, as:command, rename-to:"jq"         # json query

    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"

    zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load: "wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"

    # zplug "b4b4r07/enhancd", use:init.sh       # enhance cd command
    # zplug "changyuheng/zsh-interactive-cd"     # enhance cd command with fzf search
    zplug "unixorn/tumult.plugin.zsh", lazy:true # enhance functionality for macos; https://github.com/unixorn/tumult.plugin.zsh#included-scripts
    zplug "peterhurford/up.zsh"                  # no more cd ../../../;  just up <number>
    zplug "djui/alias-tips"                      # add alias tips when run full command
    zplug "supercrabtree/k"                      # enhance ls command
    zplug "hlissner/zsh-autopair"                # add pair symbol (), {}, [] etc.
    zplug "MichaelAquilina/zsh-auto-notify"      # auto send notification with long process completed
    zplug "ael-code/zsh-colored-man-pages"       # add color to man page
    zplug "rawkode/zsh-docker-run"               # for run any language without install them
    zplug "unixorn/docker-helpers.zshplugin"     # useful command script for execute docker
    zplug "arzzen/calc.plugin.zsh"               # calculator

    # zplug "wfxr/forgit"                        # Interactive git command
    # zplug "unixorn/git-extra-commands"         # add extra script command for git
    # zplug "laggardkernel/git-ignore"           # offline git ignore generator

    zplug "laggardkernel/zsh-thefuck"

    # load after compinit
    zplug "zdharma/fast-syntax-highlighting", defer:2
    zplug "zsh-users/zsh-history-substring-search", defer:2
    # zplug "kiurchv/asdf.plugin.zsh", defer:2

    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
  fi
}

myzs:zplug:setup-plugins() {
  if myzs:zplug:checker:plugin-installed 'zsh-users/zsh-history-substring-search'; then
    zmodload zsh/terminfo

    # shellcheck disable=SC1087,SC2154
    bindkey "$terminfo[cuu1]" history-substring-search-up
    # shellcheck disable=SC1087,SC2154
    bindkey "$terminfo[kcud1]" history-substring-search-down

    bindkey '^[[A' history-substring-search-up
    # shellcheck disable=SC1087,SC2154
    bindkey -M emacs "$terminfo[kcuu1]" history-substring-search-up
    # shellcheck disable=SC1087,SC2154
    bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up

    bindkey '^[[B' history-substring-search-down
    # shellcheck disable=SC1087,SC2154
    bindkey -M emacs "$terminfo[kcud1]" history-substring-search-down
    # shellcheck disable=SC1087,SC2154
    bindkey -M viins "$terminfo[kcud1]" history-substring-search-down

    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='fg=magenta,bold'
    export HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='fg=red,bold'
    export HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'
    export HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE='yes'
    export HISTORY_SUBSTRING_SEARCH_FUZZY=''
  fi
}
