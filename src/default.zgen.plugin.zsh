# shellcheck disable=SC1090,SC2148

export ZGEN_FORCE_SAVE=false

export ZGEN_RESET_ON_CHANGE=("${HOME}/.zshrc")

# https://github.com/hlissner/zsh-autopair#zgen--prezto-compatibility
export AUTOPAIR_INHIBIT_INIT=1

export ZGEN_PREZTO_PLUGIN_LIST=(
	# "contrib-prompt"
	"syntax-highlighting"
	"environment"
	"gnu-utility"
	"autosuggestions"
	"command-not-found"
	"directory"
	"docker"
	"fasd"
	"history-substring-search"
	"history"
	"homebrew"
	"osx"
	"utility"
	"completion"
	"prompt"
)

export ZGEN_PLUGIN_LIST=(
	"unixorn/tumult.plugin.zsh"
	"peterhurford/up.zsh"
	"djui/alias-tips"
	"supercrabtree/k"
	"unixorn/autoupdate-zgen"
	"wbingli/zsh-wakatime"
	"hlissner/zsh-autopair"
)
