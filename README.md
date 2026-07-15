# Engineering Immunity / 工程免疫

Engineering Immunity is a reusable workflow skill for AI-assisted development. It combines staged Git protection, project-isolated bug memory, regression testing, and verified cross-project prevention rules.

工程免疫是一套面向 AI 辅助开发的工作流 Skill。它把分阶段 Git 防护、项目独立 Bug 记忆、回归测试和跨项目通用预防规则组合成一条持续迭代流程。

## Core workflow / 核心流程

```text
feat/* development
  -> feature + affected regression tests
  -> develop integration and acceptance
  -> main stable release
```

- Develop each feature in an isolated `feat/*` branch, but run and integrate it inside the complete project.
- Promote only verified work to `develop` for multi-feature integration and end-to-end acceptance.
- Promote accepted work to `main` for stable release.
- Fix test-environment defects through `fix/*`; fix production defects through `hotfix/*`.
- Reproduce bugs, identify root causes, add regression tests, and record prevention rules.

## Two-level immunity / 两级免疫

```text
Current project: <project-root>/RULES-BUGS.md
Current user:    ~/.engineering-immunity/GLOBAL-IMMUNITY.md
```

`RULES-BUGS.md` belongs only to the current project. It must never be mixed with another project's bug history.

`GLOBAL-IMMUNITY.md` stores only verified cross-project engineering rules. A rule may be promoted when the same root cause appears in at least two independent projects, or when it is clearly established as a general language, framework, Git, runtime, or testing issue. The agent must notify the user before promotion.

Set `ENGINEERING_IMMUNITY_HOME` to override the default user-level directory.

## Install / 安装

### Claude Code

```bash
git clone https://github.com/anan-21/engineering-immunity.git \
  ~/.claude/skills/engineering-immunity
```

Restart Claude Code, then use `/engineering-immunity` or a natural-language prompt.

### Codex

```bash
git clone https://github.com/anan-21/engineering-immunity.git \
  ~/.codex/skills/engineering-immunity
```

Restart Codex so it can discover the new skill.

### Other agents

Install this repository in the agent's supported Skills directory if it recognizes the `SKILL.md` format. If the agent does not support Skills, point its project instructions to `SKILL.md`; natural-language use remains possible, but automatic triggering depends on the agent.

## Usage / 使用

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
Use Engineering Immunity to start the user-login feature.
Use Engineering Immunity to test this feature and promote it only if it passes.
Use Engineering Immunity to fix this bug, add a regression test, and record the prevention rule.
Use Engineering Immunity to release this feature.
We're stuck. Follow the Engineering Immunity circuit-breaker process.
```

## Project rule files / 项目规则文件

Engineering Immunity expects these files in each project root and creates missing ones when initializing a project:

```text
RULES-TECH.md
RULES-UI.md
RULES-FEATURES.md
RULES-API.md
RULES-DB.md
RULES-BUGS.md
```

The project files stay with the project. The global immunity file stays with the user. The installed Skill remains reusable and should not contain project-specific bug records.
