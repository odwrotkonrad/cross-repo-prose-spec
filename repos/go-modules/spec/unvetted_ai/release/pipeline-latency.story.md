# Feature: Fast Merge-Request Feedback from the go-modules Pipeline

<!-- [>] 🤖🤖 -->

An MR pipeline exists to tell a developer fast whether a change is sound and
what it produces. Today it takes about sixteen minutes to deliver about one
minute of work. Two causes compound: `warm-go` is a serial gate before every
unit, e2e and prerelease job, and the runner has no distributed cache, so every
job compiles the same 1422-package dependency tree cold. On one merge-request
pipeline `test-unit-che` spent 165 seconds compiling before its first test, and
the three che e2e jobs each waited about eleven minutes for three to nine
seconds of work.

This file covers the job graph: what waits on what, and why. The other half of
the fix is the build cache, specified in
[pipeline-caching.story.md](pipeline-caching.story.md). Provisioning it is
infrastructure, specified in
[infra/iac RunnerBuildCacheBehavior.story.md](../../../../infra/iac/spec/unvetted_ai/ci-cluster/RunnerBuildCacheBehavior.story.md).

## As a developer

Pushes to a merge request and waits for a verdict. Clicks no manual jobs.

### Unit feedback arrives in the first minutes (implemented)

I want `test-unit-che` and the other per-module unit jobs to start without
waiting on `warm-go`, whose artifacts they never consume,
so that a verdict lands in minutes, not after eleven.

### A manual matrix's build cost stops delaying everything (implemented)

I want `dist/che-linux-<arch>`, consumed only by the manual
`test-e2e-install-methods` matrix, off the critical path,
so that about 107 seconds leaves the time-to-first-signal on an unclicked
pipeline.

### e2e jobs stop waiting eleven minutes for nine seconds of work (implemented)

I want `test-e2e-che-{dryrun,run,backup}` still gated on `warm-go`, which they
do consume, but reached sooner once it sheds unused work,
so that the wait matches the dependency.

### The registry sweep starts with the unit jobs (todo)

I want `test-e2e-che-registry` linking its own harness and needing no job,
so that an upstream-name check never queues behind a build it can do without.

### A prerelease arrives sooner without loosening its gates (implemented)

I want the prerelease `needs` list unchanged while its gates clear earlier,
so that prereleases publish sooner, still never from failing code, nothing in
[mr-prereleases.story.md](mr-prereleases.story.md) changing.

## As a pipeline maintainer

Shapes the job graph against a fixed node size. Adds no concurrency inside jobs.

### The manual matrix still gets its binary on demand (implemented)

I want the linux cross-build in its own manual job, consumed when clicked,
rebuilt by the matrix when not,
so that an unclicked pipeline stays correct without operator knowledge.

### Speed is sought where cores exist (implemented)

I want work spread across more jobs, not backgrounded inside one, given a 4
vCPU node fits exactly two medium pods and `go build ./...` already
parallelises,
so that `Unschedulable: Insufficient cpu` reads as the node packing described
in [infra/iac ci-cluster](../../../../infra/iac/spec/unvetted_ai/ci-cluster/GkeRunnerClusterBehavior.story.md),
not a fault here.

<!-- [<] 🤖🤖 -->
