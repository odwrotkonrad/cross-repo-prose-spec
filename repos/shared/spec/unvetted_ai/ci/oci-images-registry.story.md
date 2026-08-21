# Feature: Every OCI image in CI goes through Artifact Registry

<!-- [>] 🤖🤖 -->

Artifact Registry in the CI project is the one registry CI touches. Every
image a job pulls, by any path, resolves there: the job `image:`, each
`services:` entry, a Dockerfile `FROM` the build daemon resolves, a tool image a
script `docker run`s, the runner manager and helper. Every image a job builds
is pushed there or nowhere: an artifact tarball, a local daemon tag, never a
public registry, never the GitLab container registry.

Where the registry lives and which identity may read or write:
[iac ImageRegistryBehavior](../../../../cross-repo/infra/iac/spec/unvetted_ai/ci-cluster/ImageRegistryBehavior.story.md).
How `ci-linux` is published:
[oci-images ImagePublishingBehavior](../../../../cross-repo/infra/oci-images/spec/unvetted_ai/registry/ImagePublishingBehavior.story.md).
This file is the rule every repo's pipeline obeys. Convention:
`conventions/ci/convention.md`, "Images". Requirements:
`technical-requirements.md` beside this file.

Two identities pull. The kubelet fetches `image:` and `services:` as the node
account. A `docker pull`, `docker run` or `docker build` inside a job goes
through the `docker:dind` service daemon, which holds no credential of its
own: the docker CLI in the job container sends one per request, read from
`~/.docker/config.json`. The runner writes that file before every job, as it
already writes the go proxy `.netrc`. No pipeline logs in. A proxy path on a
`FROM` line with no credential is a denied pull, and a Dockerfile default of a
public image turns that denial into a silent fallback to Docker Hub.

## As a CI maintainer

Writes `.gitlab-ci.yml` and the scripts it calls. Provisions no registry.

### The job image is always ours, pinned (implemented)

I want every job `image:` either `$ARTIFACT_REGISTRY/ci-linux*:$CI_IMAGES_REF`
or a `$ARTIFACT_REGISTRY_PROXY_*` path at an immutable tag,
so that no job pod asks a public registry for its own image and a rerun of an
old pipeline runs the image it originally ran.

### A third-party job image goes through the proxy (implemented)

I want `squidfunk/mkdocs-material` in go-modules named through
`$ARTIFACT_REGISTRY_PROXY_DOCKERHUB` like `ruby`, `python` and `docker`,
so that no bare Docker Hub `image:` remains in the group.

### A service image is a registry path with an alias (implemented)

I want every `services:` entry a `$ARTIFACT_REGISTRY_PROXY_*` path with an
explicit `alias`,
so that the daemon comes from the registry and the job still reaches it as
`docker`.

### A tool image a script runs comes from the proxy (implemented)

I want every `docker run` of a tool image (`tonistiigi/binfmt` in go-modules
and oci-images) named through the proxy and pulled explicitly before the run,
so that the implicit pull behind `docker run`, which carries no credential,
never reaches for a public image.

### A base image is passed in, never read from the Dockerfile (implemented)

I want every in-CI `docker build` of a Dockerfile with `ARG BASE_IMAGE` given
`--build-arg BASE_IMAGE=$ARTIFACT_REGISTRY_PROXY_DOCKERHUB/...`, including the
go-modules e2e harness fallback that builds `install-methods.Dockerfile`
itself (`CHE_E2E_BASE_IMAGE`, the name che-packages already reads),
so that no cache-cold build in CI resolves the Dockerfile's public default.

### A pipeline carries no registry login (implemented)

I want no `docker login`, token fetch or credential file written by any
`.gitlab-ci.yml` or CI script,
so that a proxy path on a `FROM` line works in every repo alike and a job
author cannot get auth wrong.

### A built image lands in the registry or stays local (implemented)

I want every image CI builds either pushed to `$ARTIFACT_REGISTRY` or kept
out of any registry, as a `--output type=docker,dest=*.tar` job artifact or a
tag inside the dind daemon,
so that no build result reaches a public registry or the GitLab container
registry. Today only oci-images pushes, images and buildx cache alike.

### A local build still works offline from the cloud (implemented)

I want every `BASE_IMAGE` defaulting to the public image in the Dockerfile and
every base env var (`CHE_E2E_BASE_IMAGE`) unset by default,
so that a developer builds on their own machine with no registry credential
while CI passes the proxy.

## As a reviewer

Reads an MR's pipeline changes. Runs no job by hand.

### A bare registry reference fails review mechanically (todo)

I want a check over every rendered `.gitlab-ci.yml` failing on an `image:` or
`name:` value that starts with neither `$ARTIFACT_REGISTRY`, `$CI_IMAGE` nor
`macos-`,
so that a public image cannot return through a new job nobody cross-checked
against this file.

## As an infra operator

Owns the registry, the runner, the GitLab projects. Edits no pipelines.

### The runner hands every job its registry credential (implemented)

I want the runner's `pre_build_script` writing `~/.docker/config.json` with an
`auths` entry for the registry host, user `oauth2accesstoken`, password the
pod's metadata token, beside the go proxy `.netrc` it already writes,
so that the docker CLI in any job authenticates every pull and push as the job
identity, with no key file and nothing a pipeline has to do.

### The runner manager is pulled from the registry too (implemented)

I want the gitlab-runner chart's manager image named through
`ARTIFACT_REGISTRY_PROXY_GITLAB`, as its helper image already is,
so that no `registry.gitlab.com` pull remains on the cluster.

### The GitLab container registry cannot be a push target (implemented)

I want `container_registry_access_level = "disabled"` on every project in
`infra/iac`,
so that a push to `registry.gitlab.com` fails instead of publishing an image
the cluster will not read.

### Pre-cutover images are gone from the GitLab registry (implemented)

I want the stale `konradodwrot/ai-sandbox/sandbox` repository (22 tags, last
pushed before the cutover) deleted,
so that no image exists anywhere CI does not publish to. Deleted 2026-08-21.

<!-- [<] 🤖🤖 -->
