# CI Convention

Lefthook runs pre-commit hooks. CI re-runs them over the branch diff and fails on drift. Scope per context: `prose/repos/shared/spec/unvetted_ai/ci/precommit.story.md`.

## Lefthook

- Repo `lefthook.yml` extends `~/.config/lefthook/lefthook.yml` (user-level hooks: ssh auth, conventional commit prefix, linters).
- The one repo job is `docsgen`: `make render-templates`, then `git diff --exit-code`. A commit fails if regeneration touched a tracked file. Renders fetch the pinned prose sources, so committing needs network to gitlab.com.
- A local commit runs hooks over staged files only: plain `lefthook run pre-commit`, no `--all-files`.

## CI

- Jobs call Makefile targets (`make repo-ci-precommit-diff`, `make repo-ci-precommit-all`, `make test`, `make validate`), never raw commands.
- MR and default-branch pipelines only (`workflow.rules` on `merge_request_event` and `$CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH`).
- `validate` stage, MRs only:
  - `validate-pre-commit-diff`: `make repo-ci-precommit-diff` (hooks over the branch-to-target diff), then `git diff --exit-code HEAD`. Blocking.
  - `validate-pre-commit-all`: `make repo-ci-precommit-all` (hooks over every file). `when: manual`, `allow_failure: true`.
- No pre-commit job on the default branch: its content already passed as an MR.
- CI lacks the user-level config. A stub makes `extends` resolve.

## Images

Every image a job pulls comes from Artifact Registry in `konradodwrot-ci`, over private Google access. Nothing names a public registry: a GKE job pod reaching `gitlab.com` for a pull token is the failure this removes.

Four group variables, owned by `infra/iac`, set on `konradodwrot`:

- `ARTIFACT_REGISTRY`: where `infra/oci-images` publishes `ci-linux` and `ci-linux-dind`.
- `ARTIFACT_REGISTRY_PROXY_GITLAB`, `ARTIFACT_REGISTRY_PROXY_DOCKERHUB`: pull-through caches for `registry.gitlab.com` and Docker Hub.
- `CI_IMAGES_REF`: the pinned `ci-linux` version, raised by an oci-images release.

Each is injected as `GRP_KO_VAR_<NAME>` and remapped to the bare name in the top-level `variables:` block (ci-variables convention). A repo writes `image: $ARTIFACT_REGISTRY/ci-linux:$CI_IMAGES_REF`, a third-party image `$ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/ruby:3.4` (official Docker Hub images carry `library/`). Never a floating tag: a pull-through cache serves it stale, and a rerun of an old pipeline should run the image it originally ran.

A `services:` entry needs an explicit alias once the image is a registry path, since GitLab otherwise derives the hostname from the image name:

```yaml
services:
  - name: $ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/docker:dind
    alias: docker
```

A Dockerfile `FROM` is a **separate pull** from the job's `image:`: the build daemon resolves it from the file, so repointing `image:` leaves every cache-cold build fetching from the public registry. Parameterise the base, keep the public default so a local build needs no cloud credentials, pass the proxy from CI:

```dockerfile
ARG BASE_IMAGE=debian:bookworm-slim
FROM ${BASE_IMAGE}
```

```yaml
- docker buildx build --build-arg "BASE_IMAGE=$ARTIFACT_REGISTRY_PROXY_DOCKERHUB/library/debian:bookworm-slim" ...
```

Same for anything else the build pulls, because **the job's `image:` and a pull inside the job use different identities.** The kubelet fetches the job image as the node service account. A `docker pull` or `docker build` in the script runs as the job pod's own account, through Workload Identity. Read on a registry for the node account says nothing about the build: the job image resolves, the build is denied, and what looks like a credentials bug is an IAM one.

Grant the job identity read on every repository a build may pull from. Scope write to what it publishes.

## Example

Runnable version in `example/`: `lefthook.yml`, `.gitlab-ci.yml`, `Makefile`.
