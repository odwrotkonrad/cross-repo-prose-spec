# Feature: Artifact Registry fronting every image the cluster pulls

<!-- [>] 🤖🤖 -->

Job pods fail before their first script line, in `prepare environment`, pulling
the runner helper image. Containerd answers the registry's 401 challenge by
fetching a bearer token from `gitlab.com/jwt/auth`, and that connect times out:
`dial tcp 172.65.251.78:443: i/o timeout`. The address is public Cloudflare
space, not a private range, and Cloud NAT is already sized for a packed node,
so this is transient loss of public egress rather than a routing or credentials
fault. The token fetch is anonymous: the same request without credentials
returns a token that reads the manifest, for the helper image on both
architectures and for `ci-linux`. Nothing here is an authorization problem, so
nothing here is fixed by a credential.

Retries do not cover it. The failure is a runner system failure, which the
retry rules do catch, but it consumes the same budget the flaky path already
spends.

This file covers where the cluster fetches images from: the repositories, how
nodes reach them, and what each identity may do. Which images a pipeline names,
and at which version, is that repo's concern. Publishing our own two images is
specified in
[oci-images ImagePublishingBehavior](../../../../oci-images/spec/unvetted_ai/registry/ImagePublishingBehavior.story.md).

## As a CI maintainer

Tags jobs and reads their logs. Does not provision registries.

### A job starts instead of failing to pull (implemented)

I want every image a job pod needs served from Artifact Registry in the CI
project,
so that no job fails `prepare environment` with a timeout dialling
`gitlab.com/jwt/auth`.

### The pinned image is the image that runs (implemented)

I want jobs naming an immutable version rather than a floating tag,
so that a rebuild upstream never changes what a rerun of an old pipeline
executes.

### One place names the version every repo pins (implemented)

I want the pinned image version published as a group variable on
`konradodwrot`, like the che-packages catalog version beside it,
so that raising it for the whole workspace is one change rather than an edit in
every repo.

### Repos name the registry without knowing its address (implemented)

I want the registry path published as a group variable too,
so that no `.gitlab-ci.yml` hardcodes a hostname that a region or project move
would invalidate.

### Third-party images stop being a single point of failure (implemented)

I want the runner helper, the docker images, `debian` and `ruby` served through
remote repositories rather than fetched from their origin per pull,
so that an outage or a slow token endpoint at a public registry does not stop
every pipeline in the group.

## As an infra operator

Applies the ci-cluster module. Owns repositories, identity and reachability.

### Pulls leave the public internet entirely (implemented)

I want private Google access enabled on the cluster subnetwork and images
resolved to the private access range,
so that image traffic never traverses NAT and the failure being fixed cannot
recur through the same path.

### Jobs keep the egress they legitimately need (implemented)

I want Cloud NAT kept in place alongside private access,
so that release downloads, apt, the Go module proxy and the GitLab API keep
working, only image pulls having moved.

### A remote repository needs no credential to hold (implemented)

I want both remote repositories configured against anonymously readable
upstreams,
so that provisioning them introduces no stored credential and no rotation.

### The node identity gains only what a pull needs (implemented)

I want the node service account granted reader on the registry and nothing
further,
so that a privileged container reaching the metadata server can fetch images
and still cannot write one.

### A build pulls under the identity that runs it (implemented)

I want the job identity granted reader on every repository a build may pull
from, not only the node account the kubelet uses,
so that a job whose own image resolves can also fetch a base or tool image,
the two being separate identities and a missing grant reading as a credentials
fault rather than the IAM one it is.

### Pushing is a separate identity from pulling (implemented)

I want write access held by a job-pod identity distinct from the node and
runner-manager accounts,
so that the ability to publish an image is granted deliberately rather than
inherited by everything running on the node.

### A job pod can prove who it is without a key (implemented)

I want job pods bound to a service account through Workload Identity,
so that publishing needs no key file in the cluster and no secret to rotate,
matching how the runner manager and the build cache already authenticate.

### Job pods are not anonymous by default (implemented)

I want the runner to name the service account its job pods run as,
so that pods stop defaulting to the namespace `default` account, which is bound
to nothing and cannot be granted anything without granting it to every workload
that also defaults.

### Write access is scoped to what we publish (implemented)

I want the push grant limited to the repository holding our own images,
so that a compromised job cannot alter the cached copies of third-party images
that every pipeline trusts.

### Build cache is stored as the disposable data it is (implemented)

I want buildx layer cache written to the registry under a retention policy that
deletes it,
so that `mode=max` cache does not accumulate indefinitely while published
version tags are kept.

### The reader learns which images are ours (implemented)

I want our published images in a standard repository and third-party ones in
remote repositories,
so that the split between what we build and what we merely cache is visible in
the layout rather than inferred from image names.

### A cache of our own build is recognised as pointless (implemented)

I want our own images published to the registry directly rather than pulled
through a remote repository fronting where we pushed them,
so that no build result makes a round trip out to a public registry and back to
be read by the cluster that produced it.

## As an account owner watching spend

Reads the billing report. Sets the ceilings, not the repository layout.

### Registry traffic crosses no billed boundary (implemented)

I want the registry co-located with the cluster's region,
so that every pull is in-region, with no egress charge for images fetched many
times a day.

### Cached copies do not grow without bound (implemented)

I want build cache bounded by policy,
so that storage for reproducible data stays a rounding error against spot
compute spend.

### Remote repository contents expire too (todo)

I want a cleanup policy on both remote repositories,
so that cached third-party layers nobody pulls any more stop being stored.

<!-- [<] 🤖🤖 -->
