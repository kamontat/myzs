#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by 2.3.2
# link (https://github.com/Template-generator/script-genrating/tree/2.3.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

echo "[1/7] Prepare and update version:
        1. update \$__MYZS__VERSION
        2. update \$__MYZS__LAST_UPDATED
        3. update docs/CHANGELOG.md file"

echo "[2/7] List all tags that already exist:"
git tag --column

# shellcheck disable=SC2034
printf "[3/7] Enter release version: (current=%s)" "${__MYZS__VERSION}"
if ! git tag | grep -q "^${__MYZS__VERSION}$"; then
  VERSION="$__MYZS__VERSION"
  echo
else
  echo
  printf "[error] current version have been released, look to [1/7] step"
  echo

  exit 1
  # read -r ans
  # VERSION="$ans"
fi

# checking
test -z "$VERSION" && exit 1

echo "[4/7] Add all changes to git"
git add .

echo "[5/7] Commit all changes with release version message"
git commit --allow-empty -m "chore(release): version $VERSION"

echo "[6/7] create new git tag called $VERSION"
git tag "$VERSION"

echo "[7/7] push all changes and tag to Github repository"
git push && git push --tag

unset VERSION
