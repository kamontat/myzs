# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

__myzs__create_plugins() {
  zplug 'zplug/zplug', hook-build:'zplug --self-manage'

  if __myzs_is_command_exist "myzs__plugins_list"; then
    myzs__plugins_list
  else
    # zplug "b4b4r07/httpstat", as:command, use:'(*).sh', rename-to:'$1' # like curl -v
    # zplug "stedolan/jq", from:gh-r, as:command, rename-to:"jq"         # json query

    zplug "zsh-users/zsh-autosuggestions"
    zplug "zsh-users/zsh-completions"

    zplug "mfaerevaag/wd", as:command, use:"wd.sh", hook-load: "wd() { . $ZPLUG_REPOS/mfaerevaag/wd/wd.sh }"

    # zplug "b4b4r07/enhancd", use:init.sh
    # zplug "changyuheng/zsh-interactive-cd" # enhance cd command with fzf search
    zplug "unixorn/tumult.plugin.zsh" # enhance functionality for macos; https://github.com/unixorn/tumult.plugin.zsh#included-scripts
    zplug "peterhurford/up.zsh"       # no more cd ../../../;  just up <number>
    zplug "djui/alias-tips"
    zplug "supercrabtree/k"
    zplug "hlissner/zsh-autopair"
    zplug "MichaelAquilina/zsh-auto-notify" # auto send notification with long process completed
    zplug "arzzen/calc.plugin.zsh"          # calculator
    zplug "ael-code/zsh-colored-man-pages"

    zplug "rawkode/zsh-docker-run"                                  # for run any language without install them
    zplug "unixorn/docker-helpers.zshplugin"                        # useful command script for execute docker
    zplug "webyneter/docker-aliases", use:docker-aliases.plugin.zsh # alias docker command

    # zplug "kiurchv/asdf.plugin.zsh", defer:2

    # zplug "wfxr/forgit"                # Interactive git command
    # zplug "unixorn/git-extra-commands" # add extra script command for git
    # zplug "laggardkernel/git-ignore"   # offline git ignore generator

    zplug "laggardkernel/zsh-thefuck"

    zplug "zdharma/fast-syntax-highlighting", defer:2

    zplug "mafredri/zsh-async", from:github
    zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
  fi
}
