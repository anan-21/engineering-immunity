#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
init_script="$repo_root/skills/engineering-immunity/scripts/init-project.sh"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/engineering-immunity-isolation.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

mkdir -p "$tmp/project-a" "$tmp/project-b"
git -C "$tmp/project-a" init -q
git -C "$tmp/project-b" init -q

ENGINEERING_IMMUNITY_HOME="$tmp/global" "$init_script" "$tmp/project-a" >/dev/null
ENGINEERING_IMMUNITY_HOME="$tmp/global" "$init_script" "$tmp/project-b" >/dev/null

printf '\n### Bug #001: Project A only\n' >> "$tmp/project-a/RULES-BUGS.md"

if grep -q "Project A only" "$tmp/project-b/RULES-BUGS.md"; then
  echo "fail: project bug leaked into project B" >&2
  exit 1
fi

if grep -q "Project A only" "$tmp/global/GLOBAL-IMMUNITY.md"; then
  echo "fail: project bug leaked into global immunity" >&2
  exit 1
fi

printf '\ncustom-project-a-rule\n' >> "$tmp/project-a/RULES-TECH.md"
ENGINEERING_IMMUNITY_HOME="$tmp/global" "$init_script" "$tmp/project-a" >/dev/null

grep -q "custom-project-a-rule" "$tmp/project-a/RULES-TECH.md"
echo "pass: project isolation and no-overwrite behavior"
