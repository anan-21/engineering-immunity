#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
skill_dir="$repo_root/skills/engineering-immunity"
skill_file="$skill_dir/SKILL.md"

test -s "$skill_file"
grep -q '^name: engineering-immunity$' "$skill_file"
grep -q '^description: ' "$skill_file"

for name in GLOBAL-IMMUNITY.md RULES-TECH.md RULES-UI.md RULES-FEATURES.md RULES-API.md RULES-DB.md RULES-BUGS.md; do
  test -s "$skill_dir/assets/templates/$name"
done

for script in "$skill_dir/scripts/init-project.sh" "$skill_dir/scripts/validate-project.sh" "$repo_root/tests/run.sh" "$repo_root/tests/test-project-isolation.sh" "$repo_root/tests/test-global-storage.sh"; do
  sh -n "$script"
done

python3 -m json.tool "$repo_root/.claude-plugin/plugin.json" >/dev/null
python3 -m json.tool "$repo_root/.claude-plugin/marketplace.json" >/dev/null
python3 -m json.tool "$repo_root/.codex-plugin/plugin.json" >/dev/null

if rg -n '\[TODO:|TODO\]' "$skill_dir" >/dev/null 2>&1; then
  echo "error: unresolved TODO placeholder in Skill package" >&2
  exit 1
fi

echo "package validation passed"
