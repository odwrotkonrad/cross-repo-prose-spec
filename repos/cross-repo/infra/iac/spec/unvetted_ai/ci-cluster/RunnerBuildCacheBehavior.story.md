# Feature: Shared build cache for the GKE runners

<!-- [>] 🤖🤖 -->

The kubernetes executor gives every job a fresh pod and discards its disk when the job
ends. Without storage outside the pod, every `cache:` block a pipeline declares is
inert: entries archive to a disk nobody will read, and every restore misses. Seen in
`go-modules`, where one job spent 202 seconds archiving 120000 files no later job could
reach, and another compiled 1422 packages cold before its first test ran.

This file covers provisioning the cache: the bucket, how the runner reaches it, what it
is allowed to reach, and how long entries live. What a pipeline puts in it, and under
which keys, is that repo's concern, specified alongside its own jobs. That includes
whether a given cost is worth caching at all, which is why `go-modules` caches compiler
output but refetches its dependencies from the public proxy.

## As a CI maintainer

Writes the `cache:` blocks and reads the job logs. Owns keys, not buckets.

### A cache entry outlives the pod that wrote it (todo)

I want the runner to declare a distributed cache backed by a bucket in the
`konradodwrot-ci` project,
so that an archived entry is readable by a later job instead of logging `No URL
provided, cache will not be downloaded from shared cache server`.

### Sibling jobs and later pipelines start warm (todo)

I want one populated cache key readable across pipelines,
so that a merge request opened after an earlier one compiles warm rather than
cold.

### A cache miss never fails a job (todo)

I want a job to proceed and succeed against an unreachable, misconfigured or
empty cache,
so that CI slows without breaking.

### Signing failures are visible in the log (todo)

I want transfer failures other than a missing entry logged as errors,
so that a permanently unsignable cache is noticed rather than absorbed as
repeated cold builds forever.

### Keying stays with the pipeline that owns it (implemented)

I want what to cache and under which keys specified alongside each repo's jobs,
so that this module guarantees only persistence, reachability and expiry.

### The cache is not a trust boundary (implemented)

I want key-space separation between jobs at different trust levels left to the
pipeline,
so that nobody assumes the shared bucket isolates keys on its own.

## As an infra operator

Provisions the bucket and the grants. Pays the storage bill.

### No long-lived key on disk (todo)

I want cache reads and writes authenticated through the runner's existing
Workload Identity binding,
so that provisioning the cache introduces no key file and no new secret to
rotate.

### The runner can sign the URLs it uses (todo)

I want `iam.serviceAccounts.signBlob` on the runner's own service account
alongside object access,
so that archive and restore succeed instead of logging `unable to sign bytes:
Permission 'iam.serviceAccounts.signBlob' denied`.

### Object access alone is not mistaken for cache access (todo)

I want both grants made deliberately as a pair,
so that a cache that looks correctly configured is not silently inert in every
pipeline.

### A compromised runner reaches nothing else (todo)

I want the cache grant scoped to object read and write on the cache bucket and
signing scoped to the runner's own service account,
so that no other bucket or project is reachable.

### The bucket is not a distribution channel (implemented)

I want public access prevented and uniform bucket-level access enforced,
so that no per-object ACL can widen reach to compiler output.

### Disposable data is not kept like data (implemented)

I want a lifecycle rule deleting objects and versioning off,
so that reproducible cache contents are not retained as though a superseded
entry had recovery value.

### Retention is one day, not a week (implemented)

I want the window set to one day, every pipeline rewriting the keys it touches,
so that storage falls roughly sevenfold at an unchanged hit rate, the whole
cost being one cold build for a branch left idle overnight.

### Deleted entries stop being billed at once (implemented)

I want soft delete disabled outright,
so that constantly superseded objects are not billed through the seven-day
default that would silently undo the short lifecycle window.

### Abandoned uploads do not accumulate (todo)

I want a lifecycle rule aborting incomplete multipart uploads older than a day,
so that parts orphaned by a preempted pod, reachable by no object-age rule,
stop being billed.

### The bucket tears down without hand-emptying (todo)

I want destroy or replace to succeed on a never-empty bucket holding nothing
worth preserving,
so that no operator deletes objects first.

### Storage stays bounded over weeks (todo)

I want expired objects removed without operator intervention,
so that steady-state cache storage is bounded and known, like the node caps in
[GkeRunnerClusterBehavior.md](GkeRunnerClusterBehavior.story.md).

### The cheapest class the access pattern allows (implemented)

I want the default storage class standard,
so that entries deleted within days incur no minimum-storage-duration charge
from nearline or coldline.

### Cache traffic crosses no billed boundary (implemented)

I want a single-region bucket co-located with the cluster's zone,
so that every read and write is in-region, with no egress charge and no
multi-region replication paid for disposable data.

### Cache spend stays a rounding error (todo)

I want steady-state cache cost held to a small fraction of spot compute spend,
so that the pipeline time removed is worth more than the storage, the retention
window shortening rather than the cache being abandoned if that stops holding.

### Nothing bad persists past the window (todo)

I want a stale, corrupt or poisoned entry to age out on its own,
so that no cache entry is trusted indefinitely on the strength of having once
been written.

<!-- [<] 🤖🤖 -->
