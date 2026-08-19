# Feature: Publishing the CI images to Artifact Registry

<!-- [>] 🤖🤖 -->

The images built here are pulled by every repo's jobs on the GKE cluster, and
that pull is what fails: containerd cannot reach the token endpoint the GitLab
registry redirects it to. Rather than caching our own build back through the
registry that cannot be reached, the build publishes to Artifact Registry in
`konradodwrot-ci` directly, where the cluster reads it over private access.

Where the cluster fetches from, and which identity may write, is specified in
[iac ImageRegistryBehavior](../../../../iac/spec/unvetted_ai/ci-cluster/ImageRegistryBehavior.story.md).
This file covers what this repo publishes and how it authenticates to do so.

The build runs buildx inside a docker-in-docker service container, so the job
container holds the credentials and the daemon performing the push does not.
Several stories below exist only because of that split.

## As a CI maintainer

Consumes the published images. Does not build them.

### The image a pipeline pins exists to be pulled (implemented)

I want each release publishing an immutable version tag to Artifact Registry,
so that a repo pinning that version gets the same image on every run rather
than whatever last overwrote a floating tag.

### Both architectures come from one published version (implemented)

I want the multi-arch manifest published under a single tag,
so that an arm64 and an amd64 job name the same version and each receives the
image matching its node.

### The version to pin is discoverable without reading a build log (implemented)

I want the released version recorded where the workspace already reads pinned
versions from,
so that raising every repo's pin does not mean inspecting registry tags by
hand.

## As an image maintainer

Owns the Dockerfile, the build jobs and what they publish.

### The build authenticates with no key in the repo (implemented)

I want the push authenticated by the job pod's bound identity, taking a
short-lived token at build time,
so that publishing needs no service account key stored as a CI variable and
nothing to rotate.

### Credentials are obtained where they exist (implemented)

I want the registry login performed in the job container rather than the
docker-in-docker service,
so that the token from the metadata server, which only the job pod's identity
can obtain, is the one the push uses.

### The login works in the image the job actually runs (implemented)

I want the token read with the tools the docker CLI image ships,
so that fetching it does not assume a JSON parser or an HTTP client absent from
a busybox userland, as the version lookup beside it already accounts for.

### A merge request still builds without publishing (implemented)

I want merge request pipelines exporting cache only, as they do now,
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
so that no job is left pulling one image from the old registry and another from
the new.

### The bootstrap job still bootstraps (implemented)

I want the validate job continuing to start from a minimal base image rather
than this repo's own output,
so that a broken or absent `ci-linux` can still be fixed by a pipeline that
does not depend on it.

### The base image is fetched through the proxy too (implemented)

I want the `FROM` line resolved through the registry rather than named as a
public image,
so that a cache-cold build does not reach a public registry for the base layer,
the build daemon reading this file being a different pull from the runner
fetching the job image.

### A local build needs no cloud credentials (implemented)

I want the base overridable, defaulting to the public image,
so that a developer runs the image build on their own machine unchanged, while
CI passes the proxy.

### Everything the build pulls goes through the registry (implemented)

I want the binfmt installer pulled through the proxy as well,
so that no step is left on a public origin, the docker-in-docker daemon that
runs it having been authenticated by the same login the pushes use.

### Publishing is not silently one-way (todo)

I want the previously published images left in place for a release cycle after
the cutover,
so that repointing a repo back is a variable change rather than a rebuild,
publishing having moved with no dual-push to fall back on.

<!-- [<] 🤖🤖 -->
