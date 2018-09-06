# shellcheck disable=SC1090,SC2148

contrib="${ZGEN_HOME}/sorin-ionescu/prezto-master/contrib"
if ! is_folder_exist "$contrib"; then
	git clone https://github.com/belak/prezto-contrib "$contrib"
	cd contrib || return 1
	git submodule init
	git submodule update
fi
