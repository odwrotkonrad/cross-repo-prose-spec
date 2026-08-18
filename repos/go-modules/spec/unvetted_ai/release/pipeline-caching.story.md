# Feature: How the go-modules Pipeline Uses the Shared Build Cache

<!-- [>] 🤖🤖 -->

Every job compiles the same 1422-package dependency tree, dominated by
gomplate's transitive AWS, GCP, go-git and OTel trees. On one merge-request
pipeline `test-unit-che` spent 165 seconds compiling before its first test ran,
and `warm-go` spent 202 seconds archiving caches that nothing could restore, no
distributed cache being configured.

Only compiler output is cached. Dependency downloads are refetched from the
public module proxy every time, left out deliberately: they are the larger half
of the cache but the cheaper half of the work.

Provisioning the cache is infrastructure, specified in
[infra/iac RunnerBuildCacheBehavior.story.md](../../../../infra/iac/spec/unvetted_ai/ci-cluster/RunnerBuildCacheBehavior.story.md).
That module guarantees only that entries persist, are reachable, and expire. It
isolates nothing between keys. This file covers what this repo decides: what is
cached, under which keys, and which jobs may write the keys a release build
reads.

## As a developer

Waits on merge-request feedback. Configures no cache.

### Unit results arrive without recompiling the world (todo)

I want `test-unit-che` to restore a populated `GOCACHE` from a reachable
distributed cache,
so that the 165 seconds of compiling before the first test falls toward zero.

## As a pipeline maintainer

Decides what is cached and under which keys. Provisions no infrastructure.

### Only reproducible build output is cached (implemented)

I want every `cache:` block to name `.cache/go-build` alone, never source,
credentials, artifacts, test results or downloads,
so that everything cached is recreatable by recompiling.

### The warming job actually fills what later jobs read (todo)

I want `warm-go` to push under the key `test-unit-che` restores, with no `pull`
job left waiting on a same-pipeline pusher,
so that warming produces a hit rather than a dependency.

### A cache declaration is never pure overhead (implemented)

I want `pull-push` archives readable by later jobs and pipelines, and the blocks
removed while no such cache exists,
so that no job pays archive time for nothing.

### Downloads are fetched, never cached (implemented)

I want no `cache:` block naming `.cache/go-mod`, `GOMODCACHE` still pointing at
a writable dir,
so that the 1.8 GB cheap half comes from the proxy while the 1.1 GB expensive
half is cached.

### Nothing is cached that is cheaper to recompute (implemented)

I want a path cached only when restoring it beats regenerating it,
so that an entry whose restore approaches a cold build is left out.

### Cache traffic and storage are not overbilled (implemented)

I want the bucket co-located with the runner cluster in `konradodwrot-ci` and on
standard storage class,
so that traffic stays in-region and short-lived entries pay no
minimum-duration charge.

### Keys never serve stale or cross-platform output (implemented)

I want a static key for build output, Go doing its own input keying, and a
distinct key naming each of host, linux amd64, linux arm64 and darwin,
so that no invalidation on `go.work` or `go.sum` is needed and no cross-compiled
cache satisfies another platform.

## As a release consumer

Installs signed published artifacts. Trusts the build that produced them.

### A merge request cannot poison a release build (implemented)

I want merge-request jobs writing distinctly prefixed cache keys no tag job
restores, splitting `prerelease-*-che` from `goreleaser-*-che`,
so that an untrusted branch has no path into a published artifact.

### The boundary is provable by reading the CI file (implemented)

I want every unprefixed `pull-push` build-cache key confined to tag-only jobs,
so that grepping the pipeline definition shows the separation without running
one.

### A release compiles cold rather than trusting unvetted input (implemented)

I want a tag job whose trusted cache expired to recompile,
so that it never falls back to a cache a merge request could have written.

### A poisoned entry cannot persist (implemented)

I want the bucket to expire objects on a short retention window,
so that a corrupt or stale entry ages out without operator action.

<!-- [<] 🤖🤖 -->
