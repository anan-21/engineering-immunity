#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
init_script="$repo_root/skills/engineering-immunity/scripts/init-project.sh"
validate_script="$repo_root/skills/engineering-immunity/scripts/validate-project.sh"
tmp=$(mktemp -d "${TMPDIR:-/tmp}/engineering-immunity-global.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

mkdir -p "$tmp/project"
git -C "$tmp/project" init -q

ENGINEERING_IMMUNITY_HOME="$tmp/custom-global" "$init_script" "$tmp/project" >/dev/null

test -s "$tmp/custom-global/GLOBAL-IMMUNITY.md"
test ! -e "$tmp/project/GLOBAL-IMMUNITY.md"
ENGINEERING_IMMUNITY_HOME="$tmp/custom-global" "$validate_script" "$tmp/project" >/dev/null

rm "$tmp/project/RULES-API.md"
if ENGINEERING_IMMUNITY_HOME="$tmp/custom-global" "$validate_script" "$tmp/project" >/dev/null 2>&1; then
  echo "fail: validation accepted a missing project rule" >&2
  exit 1
fi

echo "pass: custom global storage and validation failure behavior"
