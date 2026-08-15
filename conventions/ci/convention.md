# CI Convention

Lefthook runs the pre-commit hooks. CI re-runs them: one minimal validate job runs pre-commit over all files and fails on drift.

## Lefthook

- Repo `lefthook.yml` extends `~/.config/lefthook/lefthook.yml` (user-level hooks: ssh auth, conventional commit prefix, linters).
- Minimal repo job is the docs generation check: `docsgen` runs `make render-templates` then `git diff --exit-code`, failing the commit when regeneration changed a tracked file: generated docs never go stale in a commit.

## CI

- CI jobs run checks through Makefile targets (`make repo-ci-precommit-all`, `make test`, `make validate`), not raw commands.
- MR and default-branch pipelines (`workflow.rules` on `merge_request_event` and `$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH`).
- One `validate` stage job: `make repo-ci-precommit-all` (installs hooks, runs pre-commit over all files), then `git diff --exit-code HEAD` fails the job on any drift.
- CI lacks the user-level config, a stub makes `extends` resolve.

## Example

Runnable version in `example/`: `lefthook.yml`, `.gitlab-ci.yml`, `Makefile`.
