# CI Convention

Lefthook runs pre-commit hooks. CI re-runs them in one minimal validate job and fails on drift.

## Lefthook

- Repo `lefthook.yml` extends `~/.config/lefthook/lefthook.yml` (user-level hooks: ssh auth, conventional commit prefix, linters).
- The one repo job is `docsgen`: `make render-templates` then `git diff --exit-code`. A commit fails if regeneration changed a tracked file, so generated docs never go stale. Renders fetch the repo's pinned prose sources, so committing needs network to gitlab.com.

## CI

- Jobs call Makefile targets (`make repo-ci-precommit-all`, `make test`, `make validate`), never raw commands.
- MR and default-branch pipelines only (`workflow.rules` on `merge_request_event` and `$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH`).
- One `validate` stage job: `make repo-ci-precommit-all` (installs hooks, runs pre-commit over all files), then `git diff --exit-code HEAD`.
- CI lacks the user-level config, a stub makes `extends` resolve.

## Example

Runnable version in `example/`: `lefthook.yml`, `.gitlab-ci.yml`, `Makefile`.
