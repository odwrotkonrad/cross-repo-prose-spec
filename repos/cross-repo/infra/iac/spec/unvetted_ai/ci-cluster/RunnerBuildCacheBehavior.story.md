# Feature: Shared build cache for the GKE runners

<!-- [>] 🤖🤖 -->

The kubernetes executor gives every job a fresh pod and throws its disk away
at the end. Without storage outside the pod, every `cache:` block is inert:
entries archive to a disk nobody reads, every restore misses. Seen in
`go-modules`: one job spent 202 seconds archiving 120000 files no later job
could reach, another compiled 1422 packages cold before its first test.

This file covers provisioning the cache: the bucket, how the runner reaches
it, what it may reach, how long entries live. What a pipeline caches, under
which keys, is that repo's concern, specified beside its jobs. So is whether a
cost is worth caching at all: `go-modules` caches compiler output but
refetches dependencies from the public proxy.

## As a CI maintainer

Writes the `cache:` blocks and reads the job logs. Owns keys, not buckets.

### A cache entry outlives the pod that wrote it (implemented)

I want the runner to declare a distributed cache backed by a bucket in the CI
project,
so that a later job can read an archived entry instead of logging `No URL
provided, cache will not be downloaded from shared cache server`.

### Sibling jobs and later pipelines start warm (implemented)

I want one populated cache key readable across pipelines,
so that a merge request opened after an earlier one compiles warm.

### A cache miss never fails a job (implemented)

I want a job to proceed and succeed against an unreachable, misconfigured or
empty cache,
so that CI slows without breaking.

### Signing failures are visible in the log (implemented)

I want transfer failures other than a missing entry logged as errors,
so that a permanently unsignable cache gets noticed instead of absorbed as
endless cold builds.

### Keying stays with the pipeline that owns it (implemented)

I want what to cache and under which keys specified beside each repo's jobs,
so that this module guarantees only persistence, reachability and expiry.

### The cache is not a trust boundary (implemented)

I want key-space separation between jobs at different trust levels left to
the pipeline,
so that nobody assumes the shared bucket isolates keys on its own.

## As an infra operator

Provisions the bucket and the grants. Pays the storage bill.

### No long-lived key on disk (implemented)

I want cache reads and writes authenticated through the runner's existing
Workload Identity binding,
so that the cache adds no key file and no secret to rotate.

### The runner can sign the URLs it uses (implemented)

I want `iam.serviceAccounts.signBlob` on the runner's own service account
beside object access,
so that archive and restore work instead of logging `unable to sign bytes:
Permission 'iam.serviceAccounts.signBlob' denied`.

### Object access alone is not mistaken for cache access (implemented)

I want both grants made together, as a pair,
so that a cache that looks configured is not silently inert in every pipeline.

### A compromised runner reaches nothing else (implemented)

I want the cache grant scoped to object read and write on the cache bucket and
signing scoped to the runner's own service account,
so that no other bucket or project is reachable.

### The bucket is not a distribution channel (implemented)

I want public access prevented and uniform bucket-level access enforced,
so that no per-object ACL can expose compiler output.

### Disposable data is not kept like data (implemented)

I want a lifecycle rule deleting objects and versioning off,
so that reproducible cache contents are not kept as if a superseded entry had
recovery value.

### Retention is one day, not a week (implemented)

I want a one-day window, every pipeline rewriting the keys it touches,
so that storage falls roughly sevenfold at the same hit rate. The whole cost:
one cold build for a branch left idle overnight.

### Deleted entries stop being billed at once (implemented)

I want soft delete off,
so that constantly superseded objects are not billed through the seven-day
default that would quietly undo the short lifecycle window.

### Abandoned uploads do not accumulate (implemented)

I want a lifecycle rule aborting incomplete multipart uploads older than a
day,
so that parts orphaned by a preempted pod, which no object-age rule reaches,
stop being billed.

### The bucket tears down without hand-emptying (implemented)

I want destroy or replace to succeed on a never-empty bucket holding nothing
worth keeping,
so that no operator deletes objects first.

### Storage stays bounded over weeks (implemented)

I want expired objects removed with no operator action,
so that steady-state cache storage is bounded and known, like the node caps in
[GkeRunnerClusterBehavior.story.md](GkeRunnerClusterBehavior.story.md).

### The cheapest class the access pattern allows (implemented)

I want the default storage class standard,
so that entries deleted within days pay no nearline or coldline
minimum-storage-duration charge.

### Cache traffic crosses no billed boundary (implemented)

I want a single-region bucket in the cluster's zone,
so that every read and write is in-region: no egress charge, no multi-region
replication paid for disposable data.

### Cache spend stays a rounding error (todo)

I want steady-state cache cost held to a small fraction of spot compute
spend,
so that the pipeline time saved is worth more than the storage. If that stops
holding, the retention window shortens before the cache is dropped.

### Nothing bad persists past the window (implemented)

I want a stale, corrupt or poisoned entry to age out on its own,
so that no entry is trusted forever for having once been written.

<!-- [<] 🤖🤖 -->
