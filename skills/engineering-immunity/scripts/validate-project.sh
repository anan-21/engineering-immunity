#!/bin/sh
set -eu

release_mode=false
target=.

for arg in "$@"; do
  case "$arg" in
    --release) release_mode=true ;;
    *) target=$arg ;;
  esac
done

if ! project_root=$(git -C "$target" rev-parse --show-toplevel 2>/dev/null); then
  echo "error: '$target' is not inside a Git repository" >&2
  exit 2
fi

global_home=${ENGINEERING_IMMUNITY_HOME:-"${HOME:?HOME is required}/.engineering-immunity"}
global_file="$global_home/GLOBAL-IMMUNITY.md"
failed=0

for name in RULES-TECH.md RULES-UI.md RULES-FEATURES.md RULES-API.md RULES-DB.md RULES-BUGS.md; do
  path="$project_root/$name"
  if [ -s "$path" ]; then
    echo "ok      $name"
  else
    echo "missing $name" >&2
    failed=1
  fi
done

if [ -s "$global_file" ]; then
  echo "ok      $global_file"
else
  echo "missing $global_file" >&2
  failed=1
fi

case "$global_file" in
  "$project_root"/*)
    echo "error: global immunity store must not live inside the project" >&2
    failed=1
    ;;
esac

branch=$(git -C "$project_root" branch --show-current 2>/dev/null || true)
if [ -n "$branch" ]; then
  echo "branch  $branch"
else
  echo "warning detached HEAD or no commits" >&2
fi

if [ "$release_mode" = true ]; then
  if [ -n "$(git -C "$project_root" status --porcelain)" ]; then
    echo "error: release validation requires a clean working tree" >&2
    failed=1
  else
    echo "ok      clean working tree"
  fi
fi

if [ "$failed" -ne 0 ]; then
  exit 1
fi

echo "valid   $project_root"
