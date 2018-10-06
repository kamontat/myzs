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
export MYZS_CON="${MYZS_ROOT}/const"
export MYZS_LIB="${MYZS_ROOT}/lib"
export MYZS_SRC="${MYZS_ROOT}/src"

export MYZS_DEFAULT="${MYZS_SRC}/default"
export MYZS_PERSONAL="${MYZS_SRC}/personal"

# progress libraries
source "${MYZS_DEFAULT}/variable.main.sh"
source "${MYZS_LIB}/progress.sh"

pg_start
source "${MYZS_CON}/default.sh"
source "${MYZS_CON}/theme.sh"
source "${MYZS_CON}/location.sh"

pg_mark "Libraries" "Load helper method"
source "${MYZS_LIB}/helper.sh" || pg_mark_false "Loading helper file"
source "${MYZS_LIB}/lazyload.sh" || pg_mark_false "Loading lazyload library"
source "${MYZS_LIB}/setup.sh" || pg_mark_false "Loading setup file"

pg_mark "Libraries" "Load myzs-* method"
source "${MYZS_LIB}/public.sh" || pg_mark_false "Loading public APIs"

pg_mark "Libraries" "Load work CLI"
source "${MYZS_LIB}/location.sh" || pg_mark_false "Loading location cli"

pg_mark "Default" "Setup Zsh var"
source "${MYZS_DEFAULT}/variable.sh" || pg_mark_false "Loading default variable"

pg_mark "Personal" "Setup Zsh var"
source "${MYZS_PERSONAL}/variable.sh" || pg_mark_false "Loading personal variable"

pg_mark "Default" "Setup ZGEN setting"
source "${MYZS_DEFAULT}/zgen.setting.sh" || pg_mark_false "Setting custom zgen variable"

pg_mark "Default" "Setup ZGEN plugin"
if is_string_exist "$ZGEN_HOME" && is_file_exist "${ZGEN_HOME}/zgen.zsh"; then
	source "${MYZS_DEFAULT}/zgen.plugin.sh"
	source "${MYZS_DEFAULT}/zgen.prezto-setting.sh"
	source "${ZGEN_HOME}/zgen.zsh"

	# reset zgen
	if [[ "$RESET_ZGEN" == true ]] &&
		is_command_exist "zgen"; then
		zgen reset
	fi

	if ! zgen saved || $ZGEN_FORCE_SAVE; then
		setup=()
		for setting in "${ZGEN_PREZTO_SETTING_LIST[@]}"; do
			if [[ "$setting" == "_END_" ]]; then
				zgen prezto "${setup[@]}"
				setup=()
			else
				setup+=("$setting")
			fi
		done

		# to use prezto theme you must mark custom theme to true and do not enter any theme url
		if [[ "$CUSTOM_THEME" == true ]] && test -z "$CUSTOM_THEME_URL" &&
			is_string_exist "$CUSTOM_THEME_NAME"; then
			zgen prezto prompt theme "$CUSTOM_THEME_NAME"
		fi

		zgen prezto

		for plugin in "${ZGEN_PREZTO_PLUGIN_LIST[@]}"; do
			zgen prezto "$plugin"
		done

		for plugin in "${ZGEN_PLUGIN_LIST[@]}"; do
			zgen load "$plugin"
		done

		# generate the init script from plugins above
		zgen save
	fi
	# https://github.com/hlissner/zsh-autopair#zgen--prezto-compatibility
	autopair-init
else
	pg_mark_false "Zgen not found"
fi

pg_mark "POST" "Setup ZGEN plugin"
source "${MYZS_DEFAULT}/zgen.plugin-post.sh" || pg_mark_false "Setting (POST) zgen plugin"

pg_mark "Default" "Setup Zsh setting"
source "${MYZS_DEFAULT}/setting.sh" || pg_mark_false "Setting Zsh"

pg_mark "Default" "Setup alias"
source "${MYZS_DEFAULT}/alias.sh" || pg_mark_false "Loading alias"

pg_mark "Default" "Setup libraries"
source "${MYZS_DEFAULT}/library.sh" || pg_mark_false "Sourcing library"

pg_mark "Default" "Setup completions"
source "${MYZS_DEFAULT}/completion.sh" || pg_mark_false "Loading zsh completion"

pg_mark "Default" "Editor setting"
source "${MYZS_DEFAULT}/editor.sh" || pg_mark_false "Loading editor setting"

pg_mark "Default" "Setup prompt theme"
source "${MYZS_DEFAULT}/theme.sh" || pg_mark_false "Loading theme configuration"

pg_mark "Language" "Setup ruby rbenv"
if is_command_exist "rbenv"; then
	eval "$(rbenv init -)"
fi

pg_mark "Personal" "Setup alias"
source "${MYZS_PERSONAL}/alias.sh" || pg_mark_false "Loading custom alias"

pg_stop

if $AUTO_OPEN_PATH; then
	clipboard="$(pbpaste)"
	if is_folder_exist "$clipboard"; then
		cd "$clipboard" || echo "$clipboard not exist!"
	fi
fi
