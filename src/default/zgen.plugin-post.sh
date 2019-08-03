# shellcheck disable=SC1090,SC2148

wd_name="${HOME}/.zgen/mfaerevaag/wd-master"
if is_command_exist "git" && ! is_folder_exist "$wd_name"; then
  mkdir "$wd_name" &>/dev/null
  git clone "https://github.com/mfaerevaag/wd.git" "$wd_name" &>/dev/null

  # manpage
  cp "${wd_name}/wd.1" "/usr/share/man/man1/wd.1"
  # completion
  fpath=("$wd_name" "$fpath")
  # force rebuild zcomp
  rm -f ~/.zcompdump &&
    compinit
fi

# contrib="${HOME}/.zgen/sorin-ionescu/prezto-master/contrib"
# if ! is_folder_exist "$contrib"; then
# 	git clone https://github.com/belak/prezto-contrib "$contrib"
# 	cd contrib || exit 1
# 	git submodule init
# 	git submodule update
# fi
