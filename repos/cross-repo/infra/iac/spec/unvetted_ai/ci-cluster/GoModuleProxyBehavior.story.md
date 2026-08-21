# Feature: Artifact Registry fronting the Go module proxy

<!-- [>] 🤖🤖 -->

Every Go job in the group refetches its module tree from `proxy.golang.org`:
196 `go: downloading` lines before the first compile, ~60 jobs a day in
go-modules alone. Image pulls moved to Artifact Registry and left Cloud NAT;
module downloads did not, and they are the largest item still crossing it. On
one day the cluster pulled 43 GiB through NAT, most of it modules a job earlier
in the same pipeline had already fetched. NAT bills every byte it processes,
inbound included, on top of a gateway floor paid at zero traffic.

Artifact Registry offers a Go remote repository: a pull-through cache whose
only allowed upstream is `proxy.golang.org`. A module version is fetched from
the internet once, then served in-region over private Google access, outside
NAT, at no transfer charge.

The wiring lives on the runner, not in pipelines. Every job pod already holds
a Workload Identity; the runner's `pre_build_script` turns it into a proxy
credential and points `GOPROXY` at the cache before the job's first line runs.
No repo edits a `.gitlab-ci.yml` to benefit, and no repo can forget to. The
go-modules build cache, specified in
[go-modules pipeline-caching](../../../../../go-modules/spec/unvetted_ai/release/pipeline-caching.story.md),
keeps refusing to cache downloads: this is the cache for those.

## As an infra operator

Applies the ci-cluster module. Owns repositories, identity and reachability.

### Module downloads leave NAT the way image pulls did (implemented)

I want a `GO` format remote repository beside the docker ones, upstream
`proxy.golang.org`,
so that a module version crosses the internet once per cluster, never once
per job.

### The proxy needs no credential to hold (implemented)

I want the repository pointed at the anonymously readable public proxy,
so that provisioning it stores no upstream secret and rotates nothing.

### A job reads modules under the identity that runs it (implemented)

I want the job service account granted reader on the Go repository, like every
image repository a build may pull from,
so that a job authenticates to the proxy with the Workload Identity token it
already holds, no key file, no CI variable carrying a secret.

### Nothing in the cluster can write to the proxy (implemented)

I want no identity granted writer on the remote repository,
so that a compromised job cannot plant a module version every later build
trusts. The cache is filled only by the upstream fetch.

### The credential is minted per job, on the runner (implemented)

I want each `[[runners]]` entry to carry a `pre_build_script` that exchanges
the pod's identity for a metadata-server access token, writes it to `~/.netrc`
for the proxy host and exports `GOPROXY`,
so that the credential lives one job, in one container, and `go env GOPROXY`
prints no secret.

### The wiring survives any job image (implemented)

I want the script POSIX `sh`, fetching with `curl` or busybox `wget`, never
calling `exit`, every command guarded against `set -e`,
so that an alpine `docker:cli` job, a bare `debian:bookworm-slim` job and the
`ci-linux` image all run it and a job that cannot mint a token proceeds
unchanged rather than failing before its own script.

### A job that cannot reach the proxy builds as before (implemented)

I want `GOPROXY` exported only when a token was obtained,
so that a runner without metadata access, or a rollout gap, leaves Go on its
default proxy instead of pointed at a cache it cannot authenticate to.

### Cached modules expire too (todo)

I want a cleanup policy on the Go remote repository,
so that module versions nothing imports any more stop being stored.

## As a CI maintainer

Writes pipelines. Does not provision registries.

### Every Go job on the cluster uses the proxy without a pipeline change (implemented)

I want `GOPROXY` present in every job the GKE runners execute, in every repo,
before `before_script` runs,
so that go-modules, configs, oci-images and any future Go job share one cache
and none carries a copy of the token dance.

### A proxy miss falls through, a proxy fault does not hide (implemented)

I want `GOPROXY` to list `proxy.golang.org` after the Artifact Registry URL,
so that a module the cache cannot serve (404/410) is fetched upstream, while
an auth or server error surfaces in the job log instead of silently costing
NAT again.

### Off-cluster jobs are untouched (implemented)

I want the wiring confined to the GKE runner configuration,
so that a macOS SaaS runner and a local `make` keep Go's default proxy and
need no GCP credential.

### Repos can still name the proxy when a job needs the address (implemented)

I want the proxy path published as the group variable
`GRP_KO_VAR_ARTIFACT_REGISTRY_PROXY_GO`, beside the docker proxy variables,
so that a Dockerfile build or a dind container, where the runner's
environment does not reach, can be pointed at it without hardcoding a
hostname.

### The proxy is part of the registry artifact (implemented)

I want the new variable covered by the existing `ci-var/artifact-registry`
interface artifact, produced and consumed as one thing with the docker proxies,
so that consumers declare nothing new and the dependency graph stays honest.

## As an account owner watching spend

Reads the billing report. Sets the ceilings, not the repository layout.

### Module traffic crosses no billed boundary (implemented)

I want the Go repository in the cluster's region,
so that a cached module is served in-region, outside NAT, with no data
processing or transfer charge.

### The cache costs storage, not bandwidth (implemented)

I want the proxy's only recurring cost to be Artifact Registry storage for the
module set the group actually imports,
so that the spend is a few cents a month, bounded by what `go.sum` files name.

<!-- [<] 🤖🤖 -->
