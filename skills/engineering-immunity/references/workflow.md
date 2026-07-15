# Delivery Workflow

## Contents

- Project initialization
- Feature development
- Integration testing
- Stable release
- Bugfix and hotfix handling
- Rollback safety

## Project initialization

1. Locate the Git root.
2. Run `scripts/init-project.sh` to create missing rule files without replacing existing content.
3. Inspect the repository before filling templates. Replace placeholders only with facts supported by the project or confirmed by the user.
4. Establish `main` as stable and `develop` as integration when the project uses this branching model. Preserve an established equivalent branching strategy instead of forcing a rename.

## Feature development

1. Start from the current integration branch and create `feat/<feature>`.
2. Define acceptance criteria and affected existing flows.
3. Implement every required vertical slice in the same branch: UI, service, API, schema, configuration, documentation, and tests as applicable.
4. Run the feature in the complete project.
5. Run focused tests first, then affected regression tests, build checks, and migrations.
6. Review the diff for unrelated changes and unresolved placeholders.
7. Merge into the integration branch only after the gate passes and the user authorizes the merge.

## Integration testing

Use the integration branch to verify behavior that a feature branch cannot prove alone:

- interactions among multiple completed features;
- real test-environment configuration and services;
- database migrations and backward compatibility;
- complete user journeys and end-to-end acceptance;
- conflicts introduced by parallel work.

When a defect appears, create `fix/<issue>` from the integration branch. Re-run the failed acceptance check and affected regression suite before merging the fix back.

## Stable release

1. Confirm the integration branch is current and clean.
2. Run integration, end-to-end, build, migration, and release checks required by the project.
3. Summarize the release scope, known risks, rollback target, and evidence.
4. Merge to the stable branch only with user authorization.
5. Tag a semantic version and deploy only when requested.
6. Verify production health after deployment when access and authorization exist.

## Bugfix and hotfix handling

- Development defect: fix within the current `feat/*` branch.
- Integration defect: branch `fix/*` from the integration branch.
- Production defect: branch `hotfix/*` from the stable branch, verify narrowly and broadly, release a patch version, then propagate the commit to the integration branch.

## Rollback safety

Preserve uncommitted work and identify a known-good commit before rollback. Prefer additive recovery branches or deployment rollback over destructive history rewrites. Use `git diff`, logs, tests, and deployment evidence to establish why the rollback target is good.
