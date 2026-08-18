# CI Convention

Lefthook runs pre-commit hooks. CI re-runs them over the branch diff and fails on drift. Scope per context is specified in `prose/repos/shared/spec/unvetted_ai/ci/precommit.story.md`.

## Lefthook

- Repo `lefthook.yml` extends `~/.config/lefthook/lefthook.yml` (user-level hooks: ssh auth, conventional commit prefix, linters).
- The one repo job is `docsgen`: `make render-templates`, then `git diff --exit-code`. A commit fails if regeneration touched a tracked file, so generated docs never go stale. Renders fetch the repo's pinned prose sources, so committing needs network to gitlab.com.
- A local commit runs hooks over its staged files only: plain `lefthook run pre-commit`, no `--all-files`.

## CI

- Jobs call Makefile targets (`make repo-ci-precommit-diff`, `make repo-ci-precommit-all`, `make test`, `make validate`), never raw commands.
- MR and default-branch pipelines only (`workflow.rules` on `merge_request_event` and `$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH`).
- `validate` stage, merge requests only:
  - `validate-pre-commit-diff`: `make repo-ci-precommit-diff` (hooks over the branch-to-target diff), then `git diff --exit-code HEAD`. Blocking.
  - `validate-pre-commit-all`: `make repo-ci-precommit-all` (hooks over every file). `when: manual`, `allow_failure: true`.
- No pre-commit job on the default branch: its content passed as an MR.
- CI lacks the user-level config. A stub makes `extends` resolve.

## Example

Runnable version in `example/`: `lefthook.yml`, `.gitlab-ci.yml`, `Makefile`.
