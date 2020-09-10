# shellcheck disable=SC1090,SC2148

__myzs_initial "$0"

# Switch command

__myzs__switch_git_to() {
  local env="$1"
  local email="$2"
  local sign_key="$3"
  local gh_username="$4"

  local args=()

  if [[ "$env" == "global" ]]; then
    args+=("--global")
  elif [[ "$env" == "system" ]]; then
    args+=("--system")
  elif [[ "$env" == "worktree" ]]; then
    args+=("--worktree")
  fi

  git config \
    "${args[@]}" \
    user.email "$email"

  git config \
    "${args[@]}" \
    user.signingKey "$sign_key"

  git config \
    "${args[@]}" \
    github.user "$gh_username"
}

export GIT_PERSONAL_SIGNKEY="E9BD16F7EC800F7AFAA3C65E705CB6B32BBCBABA"
__myzs_alias "myzs-git-personal" "__myzs__switch_git_to 'global' 'developer@kamontat.net' '$GIT_PERSONAL_SIGNKEY' 'kamontat'"
__myzs_alias "mgitp" "myzs-git-personal"

export GIT_AGODA_SIGNKEY="508575A2923D2AB5997A311CDD18B41623EB11D1"
__myzs_alias "myzs-git-agoda" "__myzs__switch_git_to 'global' 'kamontat.chantrachirathumrong@agoda.com' '$GIT_AGODA_SIGNKEY' 'kchantrachir'"
__myzs_alias "mgita" "myzs-git-agoda"
