<!--[>] 🤖🤖 -->
Feature: Shared build cache for the GKE runners

The kubernetes executor gives every job a fresh pod and discards its disk when the
job ends. Without a cache backed by storage outside the pod, every `cache:` block a
pipeline declares is inert: entries are archived to a disk nobody will read, and every
restore misses. Observed in `go-modules`, where one job spent 202 seconds archiving
120000 files no later job could reach, and another compiled 1422 packages from cold
before its first test ran.

This file covers provisioning the cache: the bucket, how the runner reaches it, what
it is allowed to reach, and how long entries live. What an individual pipeline puts in
it, and under which keys, is that repo's concern, specified alongside its own jobs —
including whether a given cost is worth caching at all, which is why `go-modules`
caches compiler output but refetches its dependencies from the public proxy.

## Reachability

Scenario: a job's build cache outlives the pod that wrote it
  Status: todo
  Given the kubernetes executor discards each job's pod and its local disk when the job ends
  And the runner declares a distributed cache backed by a bucket in the `konradodwrot-ci` project
  When a job archives a cache entry
  Then the entry is written to that bucket, not only to the pod's disk
  And a later job restoring the same key reads it back
  And no job log reports `No URL provided, cache will not be downloaded from shared cache server`

Scenario: sibling jobs and later pipelines share one warm cache
  Status: todo
  Given jobs across several pipelines that compile the same dependency tree
  When one of them populates a cache key
  Then jobs in other pipelines restoring that key read what it wrote
  And a merge request opened after an earlier one starts warm rather than cold

Scenario: an unreachable cache slows CI without breaking it
  Status: todo
  Given a cache bucket that is unreachable, misconfigured, or newly empty
  When a job tries to restore a cache entry
  Then it proceeds without one and still succeeds
  And a cache miss is never itself a job failure

## Access

Scenario: the cache costs no long-lived key on disk
  Status: todo
  Given the runner already reaches GCP through Workload Identity, holding no service account key file
  When it reads from and writes to the cache bucket
  Then it authenticates through that same bound identity
  And provisioning the cache introduces no key file and no new secret to rotate

Scenario: the runner can sign the cache URLs it is allowed to use
  Status: todo
  Given the cache client reaches GCS through signed URLs
  And an identity with no key file signs by calling `signBlob` on its own service account
  When a job archives or restores a cache entry
  Then the runner signs the URL and the transfer succeeds
  And no job logs `unable to sign bytes: Permission 'iam.serviceAccounts.signBlob' denied`

Scenario: object access alone is not mistaken for cache access
  Status: todo
  Given a grant of object read and write on the bucket permits the operation but not the signing
  When the cache is provisioned
  Then the runner is granted both, and the pairing is deliberate
  And a cache that appears correctly configured is not silently inert in every pipeline

Scenario: a broken cache is noticed rather than absorbed
  Status: todo
  Given a cache miss is never a job failure, by design
  And a permanently unsignable cache therefore fails quietly on every job forever
  When cache transfers fail for a reason other than a missing entry
  Then the failure is visible in the job log as an error, not only as a slower pipeline
  And the cost shows up as repeated cold builds, which is what prompts a look

Scenario: a compromised runner cannot reach beyond its cache bucket
  Status: todo
  Given the runner's service account holds only the roles its jobs need
  When the cache grant is added
  Then it permits object read and write on the cache bucket alone
  And the signing grant is scoped to the runner's own service account, not the project
  And it grants nothing on any other bucket or project

Scenario: the cache is not a distribution channel
  Status: implemented
  Given a bucket holding compiler output that no one outside CI should fetch
  When the bucket is provisioned
  Then public access is prevented
  And uniform bucket-level access is enforced, so no per-object ACL can widen it

## Retention

Scenario: a disposable cache is not kept as though it were data
  Status: implemented
  Given cache contents are reproducible at any time by recompiling
  When the bucket is provisioned
  Then a lifecycle rule deletes objects after a short retention window
  And object versioning stays off, a superseded cache entry having no recovery value

Scenario: retention is no longer than the entries stay useful
  Status: implemented
  Given every pipeline rewrites the cache keys it touches
  And an entry older than a day is one no active branch is exercising
  When the retention window is chosen
  Then it is one day, not a week
  And the hit rate is materially unchanged, because live branches refresh their own entries
  And storage falls roughly sevenfold against a week-long window
  And a branch left idle overnight pays a single cold build, the whole cost of expiring early

Scenario: deleted cache entries stop being billed when they are deleted
  Status: implemented
  Given GCS retains soft-deleted objects for seven days by default, billed as stored
  And this cache overwrites the same keys on every pipeline, superseding objects constantly
  When the bucket is provisioned
  Then soft delete is disabled outright
  And an overwritten or expired entry stops incurring storage cost at once
  And the short lifecycle window is not silently undone by a longer soft-delete window

Scenario: abandoned uploads do not accumulate unnoticed
  Status: todo
  Given a job pod can be preempted mid-upload, leaving incomplete multipart parts behind
  And such parts are reachable by no object-age rule
  When they are older than a day
  Then a lifecycle rule aborts them
  And no billed fragment survives the job that orphaned it

Scenario: a disposable bucket can be torn down without hand-emptying it
  Status: todo
  Given the bucket is never empty and holds nothing worth preserving
  When it is destroyed or replaced
  Then the operation succeeds without an operator deleting objects first

Scenario: cache storage cannot grow into an unbounded bill
  Status: todo
  Given caches are rewritten on every pipeline and never pruned by the jobs themselves
  When pipelines run continuously over weeks
  Then expired objects are removed without operator intervention
  And steady-state cache storage stays bounded and known, like the node caps in
    [GkeRunnerClusterBehavior.md](GkeRunnerClusterBehavior.md)

Scenario: the bucket is billed at the cheapest class its access pattern allows
  Status: implemented
  Given cache entries are read and rewritten within days and deleted within the retention window
  When the bucket's default storage class is chosen
  Then it is standard
  And no entry incurs the minimum-storage-duration charge that nearline or coldline would apply to data deleted early

Scenario: cache traffic crosses no billed boundary
  Status: implemented
  Given the runner's job pods run in this project's cluster
  When jobs read and write cache entries on every pipeline
  Then the bucket is single-region, co-located with the cluster's zone
  And the traffic is in-region, incurring no egress charge
  And no multi-region or dual-region replication is paid for data that is disposable

Scenario: cache spend stays a rounding error against compute
  Status: todo
  Given CI compute runs on spot nodes that dominate the cluster bill
  When cache storage is added
  Then its steady-state cost is a small fraction of that compute spend
  And the time it removes from every pipeline is worth more than the storage it consumes
  And if that ceases to hold, the retention window is shortened rather than the cache abandoned

Scenario: retention is short enough that nothing bad persists
  Status: todo
  Given a cache entry may become stale, corrupt, or deliberately poisoned
  When it is not overwritten by a later pipeline
  Then it ages out on its own within the retention window
  And no cache entry is trusted indefinitely on the strength of having once been written

## Consumers

Scenario: a pipeline's own keying is its own concern
  Status: implemented
  Given the cache is a shared facility used by every repo's pipeline
  When a repo decides what to cache and under which keys
  Then that decision is specified with that repo's jobs, not here
  And this module guarantees only that entries persist, are reachable, and expire

Scenario: a shared cache does not become a shared trust boundary
  Status: implemented
  Given one bucket serves pipelines whose jobs run at different trust levels
  When a pipeline stores artifacts that a more trusted job would later restore
  Then keeping those key spaces separate is that pipeline's responsibility
  And the cache offers no isolation of its own between keys

<!--[<] 🤖🤖 -->
