# Usage:
#   source ghq-practice/move-ghq.sh
#   move_repo_to_ghq xxx

move_repo_to_ghq() {
  local src="${1:-$PWD}"
  local root origin repo_rel dst

  src="$(cd "$src" && pwd)" || return 1
  [ -d "$src/.git" ] || { echo "not a git repo: $src" >&2; return 1; }

  root="$(ghq root)" || return 1
  origin="$(git -C "$src" config --get remote.origin.url)"
  [ -n "$origin" ] || { echo "origin not found: $src" >&2; return 1; }

  repo_rel="$(printf '%s\n' "$origin" \
    | sed -E 's#^git@([^:]+):#\1/#; s#^ssh://git@##; s#^https?://##; s#\.git$##')"

  dst="$root/$repo_rel"

  [ "$src" = "$dst" ] && { echo "already in ghq root: $dst"; return 0; }
  [ -e "$dst" ] && { echo "destination exists: $dst" >&2; return 1; }

  mkdir -p "$(dirname "$dst")"
  mv "$src" "$dst"
  echo "moved: $src -> $dst"
}
