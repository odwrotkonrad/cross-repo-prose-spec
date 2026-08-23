# Technical Requirements: CI OCI images

<!-- [>] 🤖🤖 -->

## Registry

Artifact Registry in the CI GCP project, region `us-central1`, is the only
registry CI reads from or writes to.

- `ARTIFACT_REGISTRY`: standard repository `ci`. Every image the group builds,
  plus buildx layer cache.
- `ARTIFACT_REGISTRY_PROXY_DOCKERHUB`: remote repository for Docker Hub.
  Official images carry `library/`.
- `ARTIFACT_REGISTRY_PROXY_GITLAB`: remote repository for `registry.gitlab.com`.
- All three published as `GRP_KO_VAR_*` group variables by `infra/iac`, remapped
  to the bare name per the ci-variables convention.

## Pulls

Every OCI image reference in CI resolves to one of the three paths above:

- job `image:`
- `services:` `name:`, with an explicit `alias`
- Dockerfile `FROM`, through `ARG BASE_IMAGE` passed from the job
- any image a script `docker run`s or `docker pull`s
- runner manager and helper images in the cluster's runner config

Tags are immutable versions. `latest` and bare major tags are not pinned.

Registry auth lives in the runner, never in a pipeline. The runner's
`pre_build_script` writes `~/.docker/config.json` in the job container with an
`auths` entry for the registry host (`oauth2accesstoken`, the pod's metadata
token), as it writes the go proxy `.netrc`. The docker CLI sends it per request
to the dind daemon and to buildkit. No `.gitlab-ci.yml` or CI script runs
`docker login` or fetches a token. Explicit `docker pull` precedes a
`docker run` of a registry image.

Dockerfiles keep a public default for `BASE_IMAGE` for local builds. CI always
overrides it.

## Pushes

An image CI builds goes to one of:

- `ARTIFACT_REGISTRY`, images and `--cache-to` alike
- a job artifact (`--output type=docker,dest=<file>.tar`)
- the dind daemon only (`docker build --tag`, no push)

Never `registry.gitlab.com`, never Docker Hub, never another project's
registry. Remote repositories are read-only to every CI identity.

## Identities

- Node account: reader on `ci`, `remote-gitlab`, `remote-dockerhub`. Kubelet
  pulls of `image:` and `services:`.
- Job account (`ci-job`): reader on all repositories, writer on `ci` only.
  In-job pulls and every push.
- No registry key file in any CI variable.

## Out of scope

Images built and pushed on a developer host (`ai-harness/sandbox` via podman to
`localhost:5001`) and GitLab SaaS macOS VM images (`macos-*`).

<!-- [<] 🤖🤖 -->
