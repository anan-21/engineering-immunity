#!/bin/sh
set -eu

target=${1:-.}

if ! project_root=$(git -C "$target" rev-parse --show-toplevel 2>/dev/null); then
  echo "error: '$target' is not inside a Git repository" >&2
  exit 2
fi

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
skill_dir=$(CDPATH= cd -- "$script_dir/.." && pwd)
template_dir="$skill_dir/assets/templates"
global_home=${ENGINEERING_IMMUNITY_HOME:-"${HOME:?HOME is required}/.engineering-immunity"}

if [ ! -d "$template_dir" ]; then
  echo "error: template directory not found: $template_dir" >&2
  exit 2
fi

mkdir -p "$global_home"

global_file="$global_home/GLOBAL-IMMUNITY.md"
if [ -e "$global_file" ]; then
  echo "keep    $global_file"
else
  cp "$template_dir/GLOBAL-IMMUNITY.md" "$global_file"
  echo "create  $global_file"
fi

for name in RULES-TECH.md RULES-UI.md RULES-FEATURES.md RULES-API.md RULES-DB.md RULES-BUGS.md; do
  destination="$project_root/$name"
  if [ -e "$destination" ]; then
    echo "keep    $destination"
  else
    cp "$template_dir/$name" "$destination"
    echo "create  $destination"
  fi
done

branch=$(git -C "$project_root" branch --show-current 2>/dev/null || true)
if [ -n "$branch" ]; then
  echo "branch  $branch"
else
  echo "branch  detached HEAD or no commits"
fi

echo "ready   $project_root"
