# Feature: Publishing the CI images to Artifact Registry

<!-- [>] 🤖🤖 -->

Every repo's jobs on the GKE cluster pull the images built here, and that pull
is what fails: containerd cannot reach the token endpoint the GitLab registry
redirects it to. Instead of caching our own build back through an unreachable
registry, the build publishes straight to Artifact Registry in the `staging`
GCP project (`konradodwrot-ci` once renamed), where the cluster reads it over
private access.

Where the cluster fetches from, and which identity may write, is in
[iac ImageRegistryBehavior](../../../../iac/spec/unvetted_ai/ci-cluster/ImageRegistryBehavior.story.md).
This file covers what this repo publishes and how it authenticates.

The build runs buildx inside a docker-in-docker service container: the job
container holds the credentials, the daemon doing the push does not. Several
stories below exist only because of that split.

## As a CI maintainer

Consumes the published images. Does not build them.

### The image a pipeline pins exists to be pulled (implemented)

I want each release publishing an immutable version tag to Artifact Registry,
so that a repo pinning that version gets the same image every run, not
whatever last overwrote a floating tag.

### Both architectures come from one published version (implemented)

I want the multi-arch manifest published under one tag,
so that an arm64 and an amd64 job name the same version and each gets the
image for its node.

### The version to pin is discoverable without reading a build log (implemented)

I want the released version recorded where the workspace already reads pinned
versions,
so that raising every repo's pin needs no hand inspection of registry tags.

## As an image maintainer

Owns the Dockerfile, the build jobs and what they publish.

### The build authenticates with no key in the repo (implemented)

I want the push authenticated by the job pod's bound identity, a short-lived
token taken at build time,
so that publishing needs no service account key in a CI variable and nothing
to rotate.

### Credentials are obtained where they exist (implemented)

I want the registry credential in the job container's `~/.docker/config.json`,
not in the docker-in-docker service,
so that the push uses the metadata server token only the job pod's identity
can obtain. The runner writes the file before the job, see
[shared oci-images-registry](../../../../../../shared/spec/unvetted_ai/ci/oci-images-registry.story.md).

### The pipeline carries no login (implemented)

I want no token fetch and no `docker login` in this repo's pipeline,
so that the build authenticates like every other dind job in the group and
the busybox userland of the docker CLI image needs no tooling for it.

### A merge request still builds without publishing (implemented)

I want merge request pipelines exporting cache only, as now,
so that moving the destination does not turn every merge request into a
published image.

### Layer cache is reused instead of refetched over the failing path (implemented)

I want the buildx cache written to and read from the same registry as the
images,
so that a build does not pull large cache blobs across the public path this
change exists to leave.

### The dind image keeps building warm (implemented)

I want the dind build reading the base image's cache as well as its own,
so that a target sharing most of its layers is not rebuilt from scratch.

### A cutover leaves no image behind (implemented)

I want both images and both cache references moved together,
so that no job pulls one image from the old registry and another from the new.

### The bootstrap job still bootstraps (implemented)

I want the validate job still starting from a minimal base image, not this
repo's own output,
so that a broken or absent `ci-linux` can be fixed by a pipeline that does not
depend on it.

### The base image is fetched through the proxy too (implemented)

I want the `FROM` line resolved through the registry, not named as a public
image,
so that a cache-cold build does not reach a public registry for the base
layer. The build daemon reading this file is a different pull from the runner
fetching the job image.

### A local build needs no cloud credentials (implemented)

I want the base overridable, defaulting to the public image,
so that a developer builds the image on their own machine unchanged while CI
passes the proxy.

### Everything the build pulls comes from the registry (implemented)

I want the binfmt installer served through the proxy like every other image,
so that no step reaches a public registry, the job identity holding read on
each repository a build pulls from.

### Publishing is not silently one-way (todo)

I want the previously published images left in place for a release cycle after
the cutover,
so that repointing a repo back is a variable change, not a rebuild. Publishing
moved with no dual-push to fall back on.

<!-- [<] 🤖🤖 -->
