# shellcheck disable=SC1090,SC2148

SPACESHIP_PROMPT_ORDER=(
  time # Time stamps section
  package # Package version
  exec_time # Execution time
  line_sep
  user # Username section
  dir # Current directory section
  host # Hostname section
  git # Git section (git_branch + git_status)
  # node # Node.js section
  # ruby # Ruby section
  # xcode # Xcode section
  # swift # Swift section
  # golang # Go section
  # docker # Docker section
  # aws # Amazon Web Services section
  # venv # virtualenv section
  # conda # conda virtualenv section
  line_sep # Line break
  jobs
  battery # Battery level and status
  exit_code # Exit code section
  char # Prompt character
)

# SPACESHIP_RPROMPT_ORDER=(
# )

SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true

SPACESHIP_TIME_SHOW=true
SPACESHIP_TIME_FORMAT="%D{%d-%m-%Y %H.%M.%S}"
SPACESHIP_BATTERY_SHOW=always

SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_EXEC_TIME_SHOW=true
SPACESHIP_EXEC_TIME_ELAPSED=1

# SPACESHIP_VI_MODE_SHOW=true

SPACESHIP_DIR_TRUNC=2
SPACESHIP_DIR_TRUNC_PREFIX=""
