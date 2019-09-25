# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if [ "$(uname -s)" = "Darwin" ] && __myzs_is_command_exist "osascript"; then
  newtab() {

    clipboard="$(pbpaste)"

    # check is input is path
    if __myzs_is_string_exist "$1" && __myzs_is_folder_exist "$1"; then
      echo "$1" | pbcopy
      # check is clipboard is path
    elif ! __myzs_is_folder_exist "$clipboard"; then
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

  __myzs_alias "tab" "newtab"

  if __myzs_is_command_exist "system_profiler"; then
    __myzs_alias "batt" "system_profiler SPPowerDataType"
  fi
fi
