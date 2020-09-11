# shellcheck disable=SC1090,SC2148

_myzs:internal:module:initial "$0"

if _myzs:internal:checker:command-exist "git"; then
  if _myzs:internal:checker:command-exist "hub"; then
    eval "$(hub alias -s)"
  fi

  _myzs:internal:alias "g" "git"

  _myzs:internal:alias "gi" "git init"

  _myzs:internal:alias "gs" "git status"

  _myzs:internal:alias "ga" "git add"

  _myzs:internal:alias "gcm" "git commit"
  _myzs:internal:alias "gcm-sign" "git commit -S"

  _myzs:internal:alias "gco" "git checkout"
  _myzs:internal:alias "gcob" "git checkout -b"
  _myzs:internal:alias "gconb" "git checkout -b"
  _myzs:internal:alias "gcoeb" "git checkout --orphan"
  _myzs:internal:alias "gcod" "git checkout develop"
  _myzs:internal:alias "gcom" "git checkout master"

  # for git version 2.23.0
  _myzs:internal:alias "grs" "git restore"
  _myzs:internal:alias "grss" "git restore --staged"

  # for git version 2.23.0
  _myzs:internal:alias "gsw" "git switch"

  _myzs:internal:alias "gm" "git merge"

  _myzs:internal:alias "gb" "git branch"
  _myzs:internal:alias "gba" "git branch -a"
  _myzs:internal:alias "gbd" "git branch -D"
  _myzs:internal:alias "gbm" "git branch --merged"
  _myzs:internal:alias "gbnm" "git branch --no-merged"
  _myzs:internal:alias "gbr" "git fetch --all --prune" # remove remote branch, If not exist

  _myzs:internal:alias "gd" "git diff"
  _myzs:internal:alias "gdi" "git diff -w --ignore-all-space"

  _myzs:internal:alias "gt" "git tag"
  _myzs:internal:alias "gtd" "git tag -d"
  _myzs:internal:alias "gta" "git tag -a"
  _myzs:internal:alias "gt-sign" "git tag -s"

  _myzs:internal:alias "gr" "git reset"
  _myzs:internal:alias "grh" "git reset HEAD"

  _myzs:internal:alias "gf" "git fetch"

  _myzs:internal:alias "gp" "git push"
  _myzs:internal:alias "gP" "git pull"

  _myzs:internal:alias "gsp" "git stash push"
  _myzs:internal:alias "gsP" "git stash pop"

  _myzs:internal:alias "gl" "git log --graph"                       # log with graph and format in git config
  _myzs:internal:alias "gl-sign" "git log --graph --show-signature" # log with show sign information
  _myzs:internal:alias "gla" "git log --graph --all"                # log all branch and commit
  _myzs:internal:alias "glao" "git log --graph --all --oneline"     # log with oneline format
  _myzs:internal:alias "glo" "git log --graph --oneline"            # log all in oneline format
  _myzs:internal:alias "glss" "git log --graph --stat --summary"    # log with stat and summary

  ggc() {
    if ls package.json >/dev/null 2>&1 && grep -q "\"commit\":" <"package.json" >/dev/null 2>&1; then
      yarn commit "$@"
    elif _myzs:internal:checker:command-exist "committ"; then
      committ "$@"
    elif _myzs:internal:checker:command-exist "gitgo"; then
      gitgo commit "$@"
    else
      git commit "$@"
    fi
  }

  _myzs:internal:alias "cm" "ggc"
fi
