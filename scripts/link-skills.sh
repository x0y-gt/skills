#!/usr/bin/env bash
# Dev-only. Symlinks every skill in this repo into ~/.claude/skills, so editing a
# SKILL.md here takes effect in the next session with no copying.
#
# If you're on the team and just want to use the skills, install the plugin
# instead — see the README. This script is for people editing them.
set -euo pipefail
shopt -s nullglob

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dest="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
force=0
[[ "${1:-}" == "--force" ]] && force=1

# Refuse to link into the repo itself — that makes a cycle.
resolved_dest="$(cd "$dest" 2>/dev/null && pwd || true)"
case "$resolved_dest" in
  "$repo_root" | "$repo_root"/*)
    echo "error: destination $dest is inside the repo" >&2
    exit 1
    ;;
esac

mkdir -p "$dest"

blockers=()
linked=0

for skill_file in "$repo_root"/skills/*/*/SKILL.md; do
  skill_dir="$(dirname "$skill_file")"
  name="$(basename "$skill_dir")"
  target="$dest/$name"

  # A real directory means someone cp'd it here; replacing it loses local edits.
  if [[ -e "$target" && ! -L "$target" ]]; then
    if (( force )); then
      rm -rf "$target"
    else
      blockers+=("$name")
      continue
    fi
  fi

  ln -sfn "$skill_dir" "$target"
  linked=$(( linked + 1 ))
  echo "linked $name"
done

echo "$linked skill(s) linked into $dest"

if (( ${#blockers[@]} )); then
  echo >&2
  echo "skipped — a real directory is already there: ${blockers[*]}" >&2
  echo "those are stale copies; re-run with --force to replace them" >&2
  exit 1
fi
