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

## Images

Every image a job pulls comes from Artifact Registry in `konradodwrot-ci`, over private Google access. Nothing names a public registry: a job pod on the GKE cluster reaching `gitlab.com` for a pull token is the failure this exists to remove.

Four group variables, all owned by `infra/iac` and set on `konradodwrot`:

- `ARTIFACT_REGISTRY`: where `infra/oci-images` publishes `ci-linux` and `ci-linux-dind`.
- `ARTIFACT_REGISTRY_PROXY_GITLAB`, `ARTIFACT_REGISTRY_PROXY_DOCKERHUB`: pull-through caches for `registry.gitlab.com` and Docker Hub.
- `CI_IMAGES_REF`: the `ci-linux` version to pin, raised by an oci-images release.

Each is injected as `GRP_KO_VAR_<NAME>` and remapped to the bare name in the pipeline's top-level `variables:` block (ci-variables convention). So a repo writes `image: $ARTIFACT_REGISTRY/ci-linux:$CI_IMAGES_REF`, and a third-party image `$ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/ruby:3.4` (official Docker Hub images carry the `library/` prefix). Never a floating tag: a pull-through cache serves one stale, and a rerun of an old pipeline should run the image it originally ran.

A `services:` entry needs its alias stated once the image is a registry path, since GitLab otherwise derives the hostname from the image name:

```yaml
services:
  - name: $ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/docker:dind
    alias: docker
```

A Dockerfile `FROM` is a **separate pull** from the job's `image:`: the build daemon resolves it by reading the file, so repointing `image:` leaves it fetching from the public registry on every cache-cold build. Parameterise the base, keeping the public default so a local build needs no cloud credentials, and pass the proxy from CI:

```dockerfile
ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE}
```

```yaml
- docker buildx build --build-arg "BASE_IMAGE=$ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/debian:bookworm-slim" ...
```

The same holds for anything the build pulls itself, and the reason is worth stating: **the job's `image:` and a pull inside the job use different identities.** The kubelet fetches the job image as the node service account; a `docker pull` or `docker build` in the script runs as the job pod's own account, through Workload Identity. Granting the node account read on a registry therefore says nothing about whether a build can pull from it — the job image resolves while the build is denied, which reads as a credentials bug and is an IAM one.

Grant the job identity read on every repository a build may pull from, and keep write scoped to what it publishes.

## Example

Runnable version in `example/`: `lefthook.yml`, `.gitlab-ci.yml`, `Makefile`.
