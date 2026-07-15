# Engineering Immunity / 工程免疫

[![Validate](https://github.com/anan-21/engineering-immunity/actions/workflows/validate.yml/badge.svg)](https://github.com/anan-21/engineering-immunity/actions/workflows/validate.yml)
[![GitHub release](https://img.shields.io/github/v/release/anan-21/engineering-immunity)](https://github.com/anan-21/engineering-immunity/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-12715B.svg)](LICENSE)

Make every verified bug fix reduce the chance of the next regression.

让每一次经过验证的 Bug 修复，都降低下一次回归的概率。

Engineering Immunity is a bilingual [Agent Skill](https://agentskills.io) for reliable AI-assisted development. It combines complete-project feature development, staged Git promotion, regression testing, project-isolated bug memory, and carefully promoted cross-project prevention rules.

## Install

Install globally and choose from the agents detected on your machine:

```bash
npx skills@1.5.17 add anan-21/engineering-immunity \
  --skill engineering-immunity \
  --global
```

If multi-agent selection does not write every target in your environment, install each agent separately:

```bash
npx skills@1.5.17 add anan-21/engineering-immunity \
  --skill engineering-immunity \
  --global \
  --agent codex

npx skills@1.5.17 add anan-21/engineering-immunity \
  --skill engineering-immunity \
  --global \
  --agent claude-code

npx skills@1.5.17 add anan-21/engineering-immunity \
  --skill engineering-immunity \
  --global \
  --agent hermes-agent
```

The open `skills` CLI supports Claude Code, Codex, Cursor, OpenCode, Hermes Agent, and many other Agent Skills-compatible tools. Installation paths and automatic invocation still depend on each agent.

Start a new agent session after installation. Existing conversations normally do not refresh their Skill catalog.

### Claude Code plugin

```text
/plugin marketplace add anan-21/engineering-immunity
/plugin install engineering-immunity@engineering-immunity
```

### Use without installing

```bash
npx skills use anan-21/engineering-immunity \
  --skill engineering-immunity \
  --agent claude-code
```

## Use it

Explicit invocation is the most reliable first test:

```text
Use $engineering-immunity to initialize this project.
```

After the agent recognizes it, natural-language triggering works too.

Chinese:

```text
按照工程免疫初始化这个项目。
按照工程免疫开发“用户登录”功能。
按照工程免疫测试这个功能，通过后进入测试版。
按照工程免疫修复这个 Bug，补回归测试并沉淀预防规则。
按照工程免疫发布这个功能。
卡住了，按工程免疫熔断流程排查。
```

English:

```text
Use Engineering Immunity to initialize this project.
Use Engineering Immunity to develop the user-login feature.
Use Engineering Immunity to test this feature and promote it only if it passes.
Use Engineering Immunity to fix this bug, add a regression test, and record the prevention rule.
Use Engineering Immunity to release this feature.
We're stuck. Follow the Engineering Immunity circuit-breaker process.
```

## How it works

```text
feat/*
  |  complete-project development
  |  feature + affected regression tests
  v
develop
  |  multi-feature integration
  |  test-environment + end-to-end acceptance
  v
main
  |  tagged stable release
  v
production
```

Feature branches isolate changes, not modules. A feature must run inside the complete project and include every necessary frontend, backend, API, database, configuration, and test change.

| Stage | Purpose | Required evidence |
|---|---|---|
| `feat/*` | Develop one deliverable feature | Feature tests, affected regression tests, build and migration checks |
| `develop` | Integrate completed features | Integration tests, real test-environment behavior, end-to-end acceptance |
| `main` | Preserve releasable code | Accepted integration state, release checks, rollback target |
| `fix/*` | Repair integration defects | Reproduced failure plus regression proof |
| `hotfix/*` | Repair production defects | Narrow fix, broad regression checks, patch release, back-propagation to `develop` |

Engineering Immunity never grants an agent permission to merge, push, tag, deploy, discard work, or rewrite history. Those actions still require user authorization.

## Two-level immunity

```text
Project memory: <project-root>/RULES-BUGS.md
User memory:    ~/.engineering-immunity/GLOBAL-IMMUNITY.md
```

Project memory never crosses repository boundaries. Switching projects discards the previous project's Bug context and loads the new project's rules.

A prevention rule enters the user-level global store only when:

- the same root cause is verified in at least two independent projects; or
- authoritative language, framework, runtime, Git, or testing behavior proves it is cross-project.

Before promotion, the agent shows the user the proposed title, scope, evidence, and prevention rule. Business rules, project paths, credentials, product preferences, and unverified guesses must remain out of global memory.

Override the user-level storage location when needed:

```bash
export ENGINEERING_IMMUNITY_HOME="$HOME/my-engineering-immunity"
```

## Project rules

The initializer creates only missing files and never overwrites existing project knowledge:

```text
RULES-TECH.md       Technology, architecture, environment, and quality gates
RULES-UI.md         Design system, interaction states, and accessibility
RULES-FEATURES.md   Scope, dependencies, acceptance criteria, and test needs
RULES-API.md        Contracts, errors, compatibility, and authentication
RULES-DB.md         Schema, migrations, indexing, backup, and recovery
RULES-BUGS.md       Reproduction, root cause, regression test, and prevention rule
```

Run the deterministic helpers directly when needed:

```bash
skills/engineering-immunity/scripts/init-project.sh /path/to/project
skills/engineering-immunity/scripts/validate-project.sh /path/to/project
skills/engineering-immunity/scripts/validate-project.sh --release /path/to/project
```

## Circuit breaker

The agent stops adding patches when the same task fails three times, fixes oscillate between two regressions, patches create patch-dependent bugs, or the user reports the same failed behavior twice.

It preserves the current state, reports the evidence, and narrows the next action to root-cause comparison, a smaller falsifiable experiment, or a known-good rollback. Rollback is a recovery tool, not a substitute for diagnosis.

## Repository structure

```text
skills/engineering-immunity/
  SKILL.md
  agents/openai.yaml
  references/
  scripts/
  assets/templates/
.claude-plugin/
.codex-plugin/
tests/
.github/workflows/validate.yml
```

## Development

```bash
sh tests/validate-package.sh
sh tests/run.sh
```

The test suite verifies project isolation, no-overwrite initialization, custom user-level storage, and validation failure behavior.

## Update

```bash
npx skills update engineering-immunity --global
```

If you maintain one shared Git checkout and link multiple agents to it, update that checkout instead. Every linked agent will use the same revision after starting a new session:

```bash
git -C ~/.local/share/engineering-immunity/repository pull
```

## Troubleshooting

List globally installed skills:

```bash
npx skills@1.5.17 list --global
```

An Agent Skill installation is structurally valid only when the agent's installed `engineering-immunity` directory exposes `SKILL.md` at its root. Do not place the full source repository directly at that destination; install or link `skills/engineering-immunity/` instead.

## License

[MIT](LICENSE)
