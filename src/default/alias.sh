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

if is_command_exist "git"; then
	if is_command_exist "hub"; then
		eval "$(hub alias -s)"
	fi

	alias g='git'
	alias gi='git init'
	alias gs='git status'
	alias gd='git diff'
	alias gr='git reset'
	alias grh='git reset HEAD'
	alias ga='git add'

	alias gc='git commit'
	alias gcm='git commit -m'
	alias gcm-sign='git commit -S -m'

	alias gt='git tag'
	alias gta='git tag -a'
	alias gt-sign='git tag -s'

	alias gco='git checkout'
	alias gcob='git checkout -b'        # checkout new branch
	alias gconb='git checkout -b'       # checkout new branch
	alias gcoeb='git checkout --orphan' # checkout empty branch
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
fi

if is_command_exist "thefuck"; then
	eval "$(thefuck --alias)" # setup thefuck
	alias f='fuck'
	alias fy='fuck --yes'
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

if is_command_exist "todolist"; then
	alias t='todolist'
	alias ta='t add'
	alias tl='t list'
	alias tc='t complete'
	alias tC='t archive'
	alias td='t delete'

	th() {
		echo "Alias help for todolist
1. t   => todolist
2. ta  => todolist add
3. tl  => todolist list
3. tc  => todolist complete
4. tC  => todolist archive
5. td  => todolist delete
    "
	}
fi

if is_command_exist "notes"; then
	alias n='notes'
	alias na='n new'
	alias nl='n ls'
	alias nf='n find'
	alias ng='n grep'
	alias nc='n cat'
	alias nrm='n rm'
	alias no='n open'
fi

if is_command_exist "nvim"; then
	alias v='nvim'
	alias vi='nvim'
	alias vim='nvim'
	alias vis='sudo nvim'
	alias svim='sudo nvim'
fi

if is_command_exist "yarn"; then
	alias y='yarn'
	alias yi='yarn install'
	alias ys='yarn start'
	alias yb='yarn build'
	alias yd='yarn dev'
fi

if [ "$(uname -s)" = "Darwin" ] && is_command_exist "osascript"; then
	newtab() {

		clipboard="$(pbpaste)"

		# check is input is path
		if is_string_exist "$1" && is_folder_exist "$1"; then
			echo "$1" | pbcopy
			# check is clipboard is path
		elif ! is_folder_exist "$clipboard"; then
			pwd | pbcopy
		fi

		the_app=$(
			osascript 2>/dev/null <<EOF
    tell application "System Events"
      name of first item of (every process whose frontmost is true)
    end tell
EOF
		)

		[[ "$the_app" == 'Terminal' ]] && {
			osascript 2>/dev/null <<EOF
    tell application "System Events"
      tell process "Terminal" to keystroke "t" using command down
    end tell
EOF
		}

		[[ "$the_app" == 'iTerm' ]] && {
			osascript 2>/dev/null <<EOF
    tell application "iTerm"
      set current_terminal to current terminal
      tell current_terminal
        launch session "Default Session"
        set current_session to current session
      end tell
    end tell
EOF
		}

		[[ "$the_app" == 'iTerm2' ]] && {
			osascript 2>/dev/null <<EOF
    tell application "iTerm2"
      tell current window
        create tab with default profile
      end tell
    end tell
EOF
		}
	}

	alias tab='newtab'
fi
