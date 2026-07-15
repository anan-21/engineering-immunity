---
name: engineering-immunity
description: Engineering Immunity is a bilingual workflow for reliable AI-assisted development using project rules, isolated feature branches, staged verification, project-specific bug memory, and verified cross-project prevention rules. Use when users mention 工程免疫 or Engineering Immunity, initialize an AI-assisted project, develop/test/release a feature, fix repeated bugs, manage feat/develop/main promotion, or ask the agent to stop recurring regressions.
---

# Engineering Immunity / 工程免疫

Use project rules, staged Git promotion, regression tests, and retained prevention rules to make each verified fix reduce future risk.

## Establish scope

1. Resolve the current project root with `git rev-parse --show-toplevel`.
2. If the directory is not a Git repository, ask the user to identify the project root before writing project rules.
3. For implementation work, run `scripts/init-project.sh <project-root>` to create only missing rule files and the user-level immunity store. Never overwrite existing rules.
4. Read the user-level `${ENGINEERING_IMMUNITY_HOME:-~/.engineering-immunity}/GLOBAL-IMMUNITY.md`, then the current project's relevant `RULES-*.md` files.
5. Never read or merge another project's `RULES-BUGS.md`. When the project changes, discard the previous project's bug context.

For questions or explanations that do not request project changes, explain the workflow without initializing files or changing Git state.

## Route the task

| User intent | Required flow |
|---|---|
| Initialize a project | Run the initializer, inspect the repository, then fill missing project rules with the user |
| Develop a feature | Follow the feature branch and complete-project verification flow |
| Test or promote | Apply the gate for the target stage; do not promote on partial evidence |
| Fix a bug | Reproduce, isolate the root cause, test the fix, and record project immunity |
| Repeated failure | Trigger the circuit breaker before adding another patch |
| Release | Verify `develop`, integrate into `main`, tag, and deploy only when the user authorizes those actions |

Read [workflow.md](references/workflow.md) for feature, integration, release, and hotfix details. Read [immunity.md](references/immunity.md) whenever fixing a bug or promoting a global rule.

## Enforce stage gates

```text
feat/* -> feature + affected regression tests -> develop
develop -> integration + end-to-end acceptance -> main
main -> tagged stable release -> production
```

- Treat `feat/*` as branch isolation, not module isolation. Build and run the feature inside the complete project.
- Before coding, list affected frontend, backend, API, database, shared component, configuration, and existing user flows.
- Do not merge a feature into `develop` until feature tests, affected regression tests, build checks, and relevant migration checks pass.
- Fix defects found on `develop` through `fix/*`; do not patch `develop` directly.
- Fix production defects through `hotfix/*` from `main`, then propagate the fix back to `develop`.
- Do not merge, push, tag, deploy, discard work, or rewrite history unless the user requested or authorized that action.

## Build immunity

After every confirmed bug fix:

1. Record the symptom, reproduction, root cause, fix, regression test, prevention rule, and affected scope in the current project's `RULES-BUGS.md`.
2. Promote only the abstract prevention rule to the user-level global store when either:
   - the same root cause is verified in at least two independent projects; or
   - authoritative language, framework, runtime, Git, or testing behavior proves it is cross-project.
3. Before global promotion, tell the user the proposed title, scope, evidence, and prevention rule. If the user asks to review, modify, or reject it, wait and do not write.
4. Never promote business rules, product preferences, project paths, credentials, one-project configuration, or unverified guesses.

## Trigger the circuit breaker

Stop modifying code when any signal occurs:

- the same task fails three consecutive attempts;
- fixing A breaks B and fixing B breaks A for two rounds;
- a patch creates another patch-dependent bug;
- the user reports the same failure twice after attempted fixes.

Preserve the current work, report the attempts and evidence, then choose with the user among root-cause comparison, scope reduction, or rollback to a known-good state. Do not treat rollback as a substitute for diagnosis.

## Verify before completion

Run `scripts/validate-project.sh <project-root>` and the repository's own tests. Report the exact checks run and any checks that could not run. Do not claim success from code inspection alone.

Use the user's language. Keep filenames and branch prefixes stable across languages.
