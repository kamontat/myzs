# shellcheck disable=SC1090,SC2148

if [[ "$MYZS_DEBUG" == "true" ]]; then
  set -x # enable DEBUG MODE
fi

if __myzs_is_command_exist "git"; then
  if __myzs_is_command_exist "hub"; then
    eval "$(hub alias -s)"
  fi

  __myzs_alias "g" "git"

  __myzs_alias "gi" "git init"

  __myzs_alias "gs" "git status"

  __myzs_alias "ga" "git add"

  __myzs_alias "gc" "git commit"
  __myzs_alias "gcm" "git commit -m"
  __myzs_alias "gcm-sign" "git commit -S -m"

  __myzs_alias "gco" "git checkout"
  __myzs_alias "gcob" "git checkout -b"
  __myzs_alias "gconb" "git checkout -b"
  __myzs_alias "gcoeb" "git checkout --orphan"
  __myzs_alias "gcod" "git checkout dev"
  __myzs_alias "gcom" "git checkout master"

  __myzs_alias "grs" "git restore"
  __myzs_alias "grss" "git restore --staged"

  __myzs_alias "gsw" "git switch"

  __myzs_alias "gb" "git branch"
  __myzs_alias "gba" "git branch -a"
  __myzs_alias "gbd" "git branch -D"
  __myzs_alias "gbm" "git branch --merged"
  __myzs_alias "gbnm" "git branch --no-merged"
  __myzs_alias "gbr" "git fetch --all --prune" # remove remote branch, If not exist

  __myzs_alias "gd" "git diff"
  __myzs_alias "gdi" "git diff -w --ignore-all-space"

  __myzs_alias "gt" "git tag"
  __myzs_alias "gtd" "git tag -d"
  __myzs_alias "gta" "git tag -a"
  __myzs_alias "gt-sign" "git tag -s"

  __myzs_alias "gr" "git reset"
  __myzs_alias "grh" "git reset HEAD"

  __myzs_alias "gf" "git fetch"

  __myzs_alias "gp" "git push"
  __myzs_alias "gP" "git pull"

  __myzs_alias "gl" "git log --graph"                       # log with graph and format in git config
  __myzs_alias "gl-sign" "git log --graph --show-signature" # log with show sign information
  __myzs_alias "gla" "git log --graph --all"                # log all branch and commit
  __myzs_alias "glao" "git log --graph --all --oneline"     # log with oneline format
  __myzs_alias "glo" "git log --graph --oneline"            # log all in oneline format
  __myzs_alias "glss" "git log --graph --stat --summary"    # log with stat and summary

  ggc() {
    if ls | grep -q "package.json" && grep -q "\"commit\":" <"package.json"; then
      yarn commit "$@"
    elif __myzs_is_command_exist "committ"; then
      committ "$@"
    elif __myzs_is_command_exist "gitgo"; then
      gitgo commit "$@"
    else
      git commit "$@"
    fi
  }

  __myzs_alias "cm" "ggc"
fi
