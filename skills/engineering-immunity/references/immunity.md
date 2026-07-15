# Immunity Rules

## Contents

- Storage boundaries
- Project bug records
- Global promotion
- Deduplication and conflicts
- Circuit-breaker evidence

## Storage boundaries

```text
Project-specific: <project-root>/RULES-BUGS.md
User-level:      ${ENGINEERING_IMMUNITY_HOME:-~/.engineering-immunity}/GLOBAL-IMMUNITY.md
Skill package:   immutable instructions and templates only
```

Never scan sibling repositories for rules. The user-level global store is the only cross-project memory channel.

## Project bug records

Record a bug only after the root cause is supported by reproduction or evidence. Use the next available ID and avoid duplicate entries for the same root cause.

Required fields:

- symptom;
- reproduction;
- root cause;
- fix;
- regression test path or command;
- prevention rule;
- affected scope;
- fixed version or commit when available.

If the root cause is still unknown, mark the entry as an investigation rather than inventing a prevention rule.

## Global promotion

Promote an abstract rule, not the project incident. Strip project names, paths, proprietary data, credentials, and business details.

Before writing, notify the user with:

```text
Cross-project immunity candidate
Title: ...
Scope: ...
Evidence: ...
Prevention rule: ...
```

The notification is not a claim of certainty. If evidence is weak, keep the rule project-local.

## Deduplication and conflicts

- Search the global file for the same root cause before adding a rule.
- Merge stronger evidence into an existing rule rather than adding a duplicate.
- Narrow the scope when a rule is framework- or version-specific.
- When a project rule conflicts with a global rule, investigate the scope difference. Do not silently overwrite either rule.

## Circuit-breaker evidence

When stopping repeated attempts, report:

- attempted approaches;
- unchanged failure signal;
- regressions introduced;
- last known-good commit or behavior;
- smallest next experiment that could falsify the current hypothesis.
