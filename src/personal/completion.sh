# shellcheck disable=SC1090,SC2148

# tabtab source for yarn package
# uninstall by removing these lines or running `tabtab uninstall yarn`
filename="$HOME/.config/yarn/global/node_modules/yarn-completions/node_modules/tabtab/.completions/yarn.zsh"
is_file_exist "$filename" && source "$filename"

HEROKU_AC_ZSH_SETUP_PATH=/Users/kchantrachir/Library/Caches/heroku/autocomplete/zsh_setup && test -f $HEROKU_AC_ZSH_SETUP_PATH && source $HEROKU_AC_ZSH_SETUP_PATH;
