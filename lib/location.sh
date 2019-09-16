# shellcheck disable=SC1090,SC2148

export rcd
rcd() {
  if is_string_exist "$WORK_ROOT"; then
    to_work_root "$1"
  fi
}

export wcd
wcd() {
  if is_string_exist "$WORKSPACE_NAME"; then
    rcd "${WORKSPACE_NAME}/$1"
  fi
}

export pcd
pcd() {
  if is_string_exist "$PROJECT_NAME"; then
    rcd "${PROJECT_NAME}/$1"
  fi
}

export lcd
lcd() {
  if is_string_exist "$LAB_NAME"; then
    rcd "${LAB_NAME}/$1"
  fi
}

export ncd
ncd() {
  if is_string_exist "$NOTE_NAME"; then
    rcd "${NOTE_NAME}"
  fi
}

export tcd
tcd() {
  if is_string_exist "$TODO_NAME"; then
    rcd "${TODO_NAME}"
  fi
}
