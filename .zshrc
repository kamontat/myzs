# shellcheck disable=SC1090,SC2148

# maintain: Kamontat Chantrachirathumrong
# version:  1.1.0
# since:    21/04/2018

# error: 2    - wrong call function or method
#        5    - file/folder not exist
#        10   - variable not exist
#        199  - raw error

ROOT="${HOME}/.zshrc"
[ -h "$ROOT" ] && ROOT="$(readlink "$ROOT")"
ROOT="$(dirname "$ROOT")"

export MYZS_ROOT="$ROOT"
export MYZS_LIB="${MYZS_ROOT}/lib"
export MYZS_SRC="${MYZS_ROOT}/src"

source "${MYZS_LIB}/constrants.sh"
source "${MYZS_LIB}/helper.sh"

source "${MYZS_SRC}/default.variable.sh"
source "${MYZS_LIB}/progress.sh"

pg_start
source "${MYZS_LIB}/lazyload.sh"

pg_mark "Fetches required library"
source "${MYZS_LIB}/setup.sh" || pg_mark_false "Loading setup file"

pg_mark "Setup variables"
source "${MYZS_SRC}/custom.variable.sh" || pg_mark_false "Setting custom variable"

pg_mark "Setup zgen"
if is_string_exist "$ZGEN_HOME" && is_file_exist "${ZGEN_HOME}/zgen.zsh"; then
	source "${MYZS_SRC}/default.zgen.plugin.zsh"
	source "${ZGEN_HOME}/zgen.zsh"

	if ! zgen saved || $ZGEN_FORCE_SAVE; then
		# prezto options
		zgen prezto editor key-bindings 'vi'
		zgen prezto editor 'dot-expansion' 'yes'

		# zgen prezto prompt theme 'spaceship'

		zgen prezto autosuggestions color 'yes'
		zgen prezto 'autosuggestions:color' found 'fg=8'

		# zgen prezto 'tmux:iterm' integrate 'yes'

		zgen prezto terminal 'auto-title' 'yes'
		zgen prezto 'terminal:window-title' format '%n@%m: %s'
		zgen prezto 'terminal:tab-title' format '%m: %s'
		zgen prezto 'terminal:multiplexer-title' format '%s'

		zgen prezto 'syntax-highlighting' color 'yes'
		zgen prezto 'syntax-highlighting' highlighters 'main' 'brackets' 'pattern' 'line' 'cursor' 'root'

		zgen prezto

		for plugin in "${ZGEN_PREZTO_PLUGIN_LIST[@]}"; do
			zgen prezto "$plugin"
		done

		for plugin in "${ZGEN_PLUGIN_LIST[@]}"; do
			zgen load "$plugin"
		done

		# zgen load denysdovhan/spaceship-prompt

		# generate the init script from plugins above
		zgen save
	fi

	# https://github.com/hlissner/zsh-autopair#zgen--prezto-compatibility
	autopair-init
else
	pg_mark_false "Zgen not found"
fi

pg_mark "Customize zgen plugin"
source "${MYZS_SRC}/custom.zgen.plugin.zsh"

pg_mark "Setup alias"
source "${MYZS_SRC}/default.alias.sh" || pg_mark_false "Loading default alias"
source "${MYZS_SRC}/custom.alias.sh" || pg_mark_false "Loading custom alias"

pg_mark "Setup libraries"
source "${MYZS_SRC}/default.library.sh" || pg_mark_false "Loading default library"

pg_mark "Setup completions"
source "${MYZS_SRC}/default.completion.sh" || pg_mark_false "Loading default completion"

pg_mark "Setup work location"
source "${MYZS_SRC}/location.sh" || pg_mark_false "Loading location cli"

pg_mark "Setup prompt theme"
source "${MYZS_SRC}/theme.sh" || pg_mark_false "Loading theme configuration"

pg_mark "Customize Zsh setting"
source "${MYZS_SRC}/custom.setting.zsh" || pg_mark_false "Setting zsh setting"

pg_stop
