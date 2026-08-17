# Feature: How the go-modules Pipeline Uses the Shared Build Cache

<!-- [>] 🤖🤖 -->

Every job compiles the same 1422-package dependency tree, dominated by gomplate's
transitive AWS, GCP, go-git and OTel trees. On one merge-request pipeline `test-unit-che`
spent 165 seconds compiling before its first test ran, and `warm-go` spent 202 seconds
archiving caches that nothing could restore, no distributed cache being configured.

Only compiler output is cached. Dependency downloads are refetched from the public module
proxy every time, left out deliberately: they are the larger half of the cache but the
cheaper half of the work.

Provisioning the cache is infrastructure, specified in
[infra/iac RunnerBuildCacheBehavior.md](../../../../infra/iac/spec/unvetted_ai/ci-cluster/RunnerBuildCacheBehavior.md).
That module guarantees only that entries persist, are reachable, and expire. It isolates
nothing between keys. This file covers what this repo decides: what is cached, under
which keys, and which jobs may write the keys a release build reads.

## What is cached

Scenario: only reproducible build output is ever cached
  Status: implemented
  Given a cache bucket shared by every repo's pipeline
  When any job in this pipeline declares a `cache:` block
  Then it names only `.cache/go-build`
  And no source, credential, build artifact, test result or downloaded dependency is cached
  And every cached path is reproducible by recompiling

Scenario: unit results arrive without recompiling the world first
  Status: todo
  Given a runner whose distributed cache the jobs can actually reach
  When `test-unit-che` runs on a merge request
  Then it restores a populated `GOCACHE` rather than starting cold
  And it starts running tests without first compiling che's full dependency tree
  And the compile-before-first-test cost falls from roughly 165 seconds toward zero

Scenario: the job that warms the cache is the one that fills it
  Status: todo
  Given `warm-go` compiles the dependency tree that later jobs need
  When it finishes
  Then what it pushed under the shared build key is what `test-unit-che` restores
  And a job declaring `pull` on a key some job in the same pipeline pushes is not left waiting on it

Scenario: cache declarations stop being pure overhead
  Status: implemented
  Given the archive step costs time proportional to the file count
  When a job finishes with a `pull-push` policy
  Then what it archives is readable by later jobs and later pipelines
  And no job spends time archiving a cache that nothing can ever restore
  And while no such cache exists, these blocks are removed rather than left to cost time for nothing

## Cost

Scenario: downloaded dependencies are fetched, never cached
  Status: implemented
  Given the public module proxy serves dependency downloads fast and free to this project
  And `GOMODCACHE` is the larger half of the cache at 1.8 GB against `GOCACHE`'s 1.1 GB
  When a job runs
  Then it downloads its modules over the public internet rather than restoring them from the cache
  And no `cache:` block names `.cache/go-mod` or any path beneath it
  And the `GOMODCACHE` variable still points at a writable directory, since jobs must unpack somewhere

Scenario: only the expensive half of the work is cached
  Status: implemented
  Given compiling che's 1422-package dependency tree costs roughly 190 seconds from cold
  And downloading those same modules costs roughly 33 seconds
  When the pipeline decides what to cache
  Then it caches compiler output, expensive to recreate
  And it leaves dependency downloads to the proxy, cheap to refetch

Scenario: nothing is cached that is cheaper to recompute than to move
  Status: implemented
  Given archiving and restoring an entry costs time proportional to its size and file count
  When a candidate path is considered for caching
  Then it is cached only if restoring it beats regenerating it
  And a path whose restore approaches the cost of a cold build is left out

Scenario: cache traffic is not billed as egress
  Status: implemented
  Given the runner's job pods and the cache bucket both live in the `konradodwrot-ci` project
  When jobs read and write cache entries continuously
  Then the bucket is co-located with the cluster so the traffic stays in-region
  And cache transfer incurs no cross-region or internet egress charge

Scenario: storage class matches how briefly an entry lives
  Status: implemented
  Given cache entries are overwritten within days and expire within the retention window
  When the bucket's storage class is chosen
  Then it is standard, not nearline or coldline
  And no entry is billed a minimum-storage-duration charge for data deleted before it elapses

## Keying

Scenario: stale compiler output is never served for changed input
  Status: implemented
  Given the Go build cache keys each entry on its own compilation inputs
  When a dependency, compiler flag or source file changes
  Then the affected entries miss and are recompiled
  And a static-string cache key is safe for build output, because Go does this keying itself
  And the build cache needs no separate invalidation on `go.work` or `go.sum`

Scenario: caches for different targets do not overwrite each other
  Status: implemented
  Given the pipeline builds for host, linux amd64, linux arm64 and darwin
  When jobs for different targets cache their build output
  Then each target uses a key naming that target
  And a cross-compiled cache never satisfies a restore for a different platform

## Trust boundary

Scenario: a merge request cannot poison the cache a release build compiles from
  Status: implemented
  Given the Go build cache serves stored contents as trusted compiler output, unverified
  And merge-request pipelines and tag pipelines both write build caches
  When a merge request job writes its build cache
  Then it writes under a key that no tag-triggered release job ever restores
  And `prerelease-darwin-che` and `goreleaser-darwin-che` no longer share one key
  And `prerelease-linux-che` and `goreleaser-linux-che` no longer share one key
  And an untrusted branch has no path into a published, signed artifact

Scenario: an operator proves the trust boundary holds by reading the CI file
  Status: implemented
  When an operator greps the pipeline definition for cache keys and their triggers
  Then every unprefixed build-cache key written with `pull-push` sits in a tag-only job
  And every merge-request job writing a build cache uses a distinctly prefixed key
  And the separation is visible without running a pipeline

Scenario: a release build pays a cold compile rather than trust unvetted input
  Status: implemented
  Given a tag pipeline whose trusted build cache expired or was never seeded
  When a release job runs
  Then it compiles from cold
  And it never falls back to a cache a merge request could have written

Scenario: a poisoned or stale entry cannot persist indefinitely
  Status: implemented
  Given the cache bucket expires objects on a short retention window
  When an entry is poisoned, corrupt, or merely stale
  Then it ages out without operator intervention
  And the pipeline's correctness never depends on a cache entry living forever

<!-- [<] 🤖🤖 -->
