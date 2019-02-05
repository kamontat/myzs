#!/usr/bin/env bash
# shellcheck disable=SC1000

# generate by 2.3.2
# link (https://github.com/Template-generator/script-genrating/tree/2.3.2)

# set -x #DEBUG - Display commands and their arguments as they are executed.
# set -v #VERBOSE - Display shell input lines as they are read.
# set -n #EVALUATE - Check syntax of the script but don't execute.

echo 'This command will pass 1 parameter as git tag (version). Then
1. Add all files in git
2. Commit with default message "[release] version: <version>"
3. Create tag
4. Push code and tags
'

echo "List of tag that exist:"
git tag --column

# shellcheck disable=SC2034
printf "Press <enter> to next or enter valid version: "
read -r ans

VERSION="$1"
test -n "$ans" && VERSION="$ans"

test -z "$VERSION" && exit 1

git add .
git commit --allow-empty -m "[release] version: $VERSION"

git tag "$VERSION"

git push && git push --tag
