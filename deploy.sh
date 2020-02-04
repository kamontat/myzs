#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by 2.3.2
# link (https://github.com/Template-generator/script-genrating/tree/2.3.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

echo "[1/6] List all tags that already exist:"
git tag --column

# shellcheck disable=SC2034
printf "[2/6] Enter release version: "
read -r ans
VERSION="$ans"
# checking
test -z "$VERSION" && exit 1

echo "[3/6] Add all changes to git"
git add .

echo "[4/6] Commit all changes with release version message"
git commit --allow-empty -m "[release] version: $VERSION"

echo "[5/6] create new git tag called $VERSION"
git tag "$VERSION"

echo "[6/6] push all changes and tag to Github repository"
git push && git push --tag
