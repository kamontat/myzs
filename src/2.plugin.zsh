# zmodload zsh/zprof
# shellcheck disable=SC1090,SC2148

# maintain: Kamontat Chantrachirathumrong
# version:  1.0.0
# since:    21/04/2018

[ "$MYZS_USE_ZPLUG" != true ] && _myzs_print_error_tofile "plugin" "MYZS_USE_ZPLUG" "set as 'false'" && return 1
! test -d "$ZPLUG_HOME" && _myzs_print_error_tofile "plugin" "variable" "directory 'ZPLUG_HOME' not exist" && return 5

source "$ZPLUG_HOME/init.zsh"

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# OH-MY-ZSH library
# zplug 'lib/bzr', from:oh-my-zsh # should disable
zplug 'lib/clipboard', from:oh-my-zsh
zplug 'lib/compfix', from:oh-my-zsh
zplug 'lib/completion', from:oh-my-zsh
# zplug 'lib/correction', from:oh-my-zsh # should disable
zplug 'lib/diagnostics', from:oh-my-zsh
zplug 'lib/directories', from:oh-my-zsh
zplug 'lib/functions', from:oh-my-zsh
# zplug 'lib/git', from:oh-my-zsh # should disable
zplug 'lib/grep', from:oh-my-zsh
# zplug 'lib/history', from:oh-my-zsh      # should disable
# zplug 'lib/key-bindings', from:oh-my-zsh # should disable
zplug 'lib/misc', from:oh-my-zsh
zplug 'lib/prompt_info_function', from:oh-my-zsh
zplug 'lib/spectrum', from:oh-my-zsh
zplug 'lib/termsupport', from:oh-my-zsh
zplug 'lib/theme-and-appearance', from:oh-my-zsh

# MacOS
zplug "plugins/osx", from:oh-my-zsh, if:"[[ $OSTYPE == *darwin* ]]"
zplug "plugins/brew", from:oh-my-zsh, if:"[[ $(command -v brew) ]]"

zplug "plugins/docker", from:oh-my-zsh, if:"[[ $MYZS_USE_DOCKER == true ]]"

zplug "plugins/sudo", from:oh-my-zsh, if:"[[ $MYZS_IS_DEVELOPER == true ]]"
zplug 'plugins/command-not-found', from:oh-my-zsh, if:"[[ $MYZS_IS_DEVELOPER == true ]]"
zplug 'plugins/colored-man-pages', from:oh-my-zsh, if:"[[ $MYZS_IS_DEVELOPER == true ]]"

zplug "plugins/git", from:oh-my-zsh, if:"[[ $MYZS_USE_GIT == true ]]"
zplug "plugins/git-extras", from:oh-my-zsh, if:"[[ $MYZS_USE_GIT == true ]]"
zplug "plugins/github", from:oh-my-zsh, if:"[[ $MYZS_USE_GIT == true ]]"

zplug "plugins/wd", from:oh-my-zsh, if:"[[ $MYZS_USE_UTIL == true ]]"
zplug "plugins/calc", from:oh-my-zsh, if:"[[ $MYZS_USE_UTIL == true ]]"
# zplug "plugins/fasd", from:oh-my-zsh, if:"[[ $MYZS_USE_UTIL == true ]]"
zplug "plugins/web-search", from:oh-my-zsh, if:"[[ $MYZS_USE_UTIL == true ]]"

zplug "plugins/node", from:oh-my-zsh, if:"[[ $MYZS_USE_NODE == true ]]"
zplug "plugins/npm", from:oh-my-zsh, if:"[[ $MYZS_USE_NODE == true ]]"
zplug "plugins/yarn", from:oh-my-zsh, if:"[[ $MYZS_USE_NODE == true ]]"
# zplug 'lib/nvm', from:oh-my-zsh, if:"[[ $MYZS_USE_NODE == true ]]"

zplug "plugins/python", from:oh-my-zsh, if:"[[ $MYZS_USE_PYTHON == true ]]"
zplug "plugins/pip", from:oh-my-zsh, if:"[[ $MYZS_USE_PYTHON == true ]]"

zplug "wbingli/zsh-wakatime", if:"[[ $MYZS_USE_WAKA == true ]]"

# zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zdharma/fast-syntax-highlighting", defer:2
zplug "hlissner/zsh-autopair", defer:2

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"

# use with `emojify`
zplug "b4b4r07/emoji-cli"
zplug "djui/alias-tips"
zplug "b4b4r07/enhancd", use:init.sh

zplug "denysdovhan/spaceship-zsh-theme", use:spaceship.zsh, from:github, as:theme

# Install packages that have not been installed yet
if ! zplug check --verbose; then
	zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load
