# shellcheck disable=SC1090,SC2148

export KEYTIMEOUT=1

# language
export LANG="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

is_folder_exist "/usr/local/opt/openssl" &&
	export PATH="$PATH:/usr/local/opt/openssl/bin" # openssl

is_folder_exist "/usr/local/opt/coreutils/libexec/gnubin" &&
	export PATH="$PATH:/usr/local/opt/coreutils/libexec/gnubin"
is_folder_exist "/Users/kamontat/.rbenv/shims" &&
	export PATH="/Users/kamontat/.rbenv/shims:$PATH"

export MANPATH="/usr/local/man:$MANPATH"

is_folder_exist "/usr/local/opt/coreutils/libexec/gnuman" &&
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
is_folder_exist "/usr/local/bin/_NDD_FOLDER/man" &&
	export MANPATH="/usr/local/bin/_NDD_FOLDER/man:$MANPATH"

# Enable ZGen Plugin Manager.
export ZGEN_HOME="$HOME/.zgen"

if is_file_exist "/usr/libexec/java_home"; then
	JAVA_HOME="$(/usr/libexec/java_home)"
	export JAVA_HOME

	export PATH="$PATH:$JAVA_HOME/bin"
fi

if is_command_exist "jenv"; then
	eval "$(jenv init -)"
	if is_folder_exist "$HOME/.jenv/bin"; then
		export PATH="$PATH:$HOME/.jenv/bin"
	fi
fi

if is_folder_exist "$HOME/Library/Android/sdk"; then
	export ANDROID_HOME="$HOME/Library/Android/sdk"                      # android home
	export PATH="$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools" # android path
fi

if is_command_exist "yarn" && is_folder_exist "$HOME/.config/yarn/global/node_modules/.bin"; then
	export PATH="$PATH:$HOME/.config/yarn/global/node_modules/.bin"
fi