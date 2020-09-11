# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:mac && _myzs:internal:checker:command-exist "osascript"; then
  newtab() {
    clipboard="$(pbpaste)"

    # check is input is path
    if _myzs:internal:checker:string-exist "$1" && _myzs:internal:checker:folder-exist "$1"; then
      echo "$1" | pbcopy
      # check is clipboard is path
    elif ! _myzs:internal:checker:folder-exist "$clipboard"; then
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

  _myzs:internal:alias "tab" "newtab"

  if _myzs:internal:checker:command-exist "system_profiler"; then
    _myzs:internal:alias "batt" "system_profiler SPPowerDataType"
  fi
fi
