# shellcheck disable=SC1090,SC2148

alias c='clear'
alias l='ls'
alias s='source'
alias srm='sudo rm -rf'
alias rmf='rm -rf'
alias la='ls --almost-all --no-group --human-readable --sort=time --format=verbose --time-style="+%d/%m/%Y-%H:%M:%S"'
alias history='fc -El 1'
alias copy-path='pwd | pbcopy'

alias restart-zsh='exec zsh'
alias restart-bash='exec bash'
if grep -q "zsh" <<<"$SHELL"; then
	alias restart-shell='restart-zsh'
elif grep -q "bash" <<<"$SHELL"; then
	alias restart-shell='restart-bash'
fi

if is_command_exist "system_profiler"; then
	alias batt='system_profiler SPPowerDataType'
fi

if is_command_exist "neofetch"; then
	if is_file_exist "$HOME/.config/neofetch/short-config"; then
		alias sysinfo='neofetch --config $HOME/.config/neofetch/short-config'
	else
		alias sysinfo='neofetch'
	fi
fi

if is_command_exist "git"; then
	alias g='git'
	alias gi='git init'
	alias gs='git status'
	alias gd='git diff'
	alias ga='git add'
	alias gc='git commit'
	alias gcm='gc -m'
	alias gcm-sign='gc -S -m'
	alias gt='git tag'
	alias gta='git tag -a'
	alias gt-sign='git tag -s'
	alias gco='git checkout'
	alias gcob='git checkout -b'
	alias gcoeb='git checkout --orphan'
	alias gcod='git checkout dev'
	alias gcom='git checkout master'

	# git branch
	alias gb='git branch'
	alias gba='git branch -a'
	alias gbD='git branch -D'
	alias gbm='git branch --merged'
	alias gbnm='git branch --no-merged'
	alias gbr='git fetch --all --prune' # remove remote branch, If not exist
	alias gp='git push'
	alias gP='git pull'

	# git log
	alias gl='git log --graph'          # log with graph and format in git config
	alias gl-sign='gl --show-signature' # log with show sign information
	alias gla='gl --all'                # log all branch and commit
	alias glo='gl --oneline'            # log with oneline format
	alias glao='gla --oneline'          # log all in oneline format
	alias glss='gl --stat --summary'    # log with stat and summary

	init_hub() {
		eval "hub alias -s" &>/dev/null
	}
	lazy_load "Hub for GitHub" init_hub hub
fi

if is_command_exist "code-insiders"; then
	alias code='code-insiders'
fi

if is_command_exist "code" || is_command_exist "code-insiders"; then
	alias newcode='code --new-window'
	alias ncode='code --new-window'
	alias ccode='code --reuse-window'
fi

if is_command_exist "atom-beta"; then
	alias atom='atom-beta'
fi

if is_command_exist "cat-syntax"; then
	alias cat='cat-syntax'
fi

if is_command_exist "fuck"; then
	alias f='fuck'
	alias fy='fuck --yes'

	# init_thefuck() {
	#   eval "thefuck --alias" &>/dev/null
	#   source "$HOME/.zshrc"
	# }
	# lazy_load "The Fuck" init_thefuck fuck
fi

if is_command_exist "gls"; then
	alias ls='gls --hyperlink=always --indicator-style=classify --color=auto'
fi

if is_command_exist "gdate"; then
	alias date=gdate
fi

if is_file_exist "${ZGEN_HOME}/mfaerevaag/wd-master/wd.sh"; then
	export wd
	wd() {
		source "${ZGEN_HOME}/mfaerevaag/wd-master/wd.sh"
	}
fi
