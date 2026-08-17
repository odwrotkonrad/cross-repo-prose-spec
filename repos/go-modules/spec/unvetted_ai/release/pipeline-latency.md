# Feature: Fast Merge-Request Feedback from the go-modules Pipeline

<!-- [>] 🤖🤖 -->

An MR pipeline exists to tell a developer fast whether a change is sound and what it
produces. Today it takes roughly sixteen minutes to deliver about one minute of real
work. Two causes compound: `warm-go` is a serial gate in front of every unit, e2e and
prerelease job, and the runner has no distributed cache, so every job compiles the same
1422-package dependency tree from cold. On one merge-request pipeline `test-unit-che`
spent 165 seconds compiling before its first test ran, and the three che e2e jobs each
waited about eleven minutes to do three to nine seconds of work.

This file covers the job graph: what waits on what, and why. The other half of the fix is
the build cache, specified in [pipeline-caching.md](pipeline-caching.md). Provisioning it
is infrastructure, specified in
[infra/iac RunnerBuildCacheBehavior.md](../../../../infra/iac/spec/unvetted_ai/ci-cluster/RunnerBuildCacheBehavior.md).

## Job graph

Scenario: unit tests start immediately instead of queueing behind a build they never use
  Status: implemented
  Given `test-unit-che` links its own test binaries and consumes no artifact from `warm-go`
  When a merge request pipeline starts
  Then it starts without waiting for `warm-go` to finish
  And the other per-module unit jobs start without waiting too
  And unit feedback arrives in the first minutes of the pipeline, not after eleven

Scenario: a manual matrix's build cost stops delaying every automatic job
  Status: implemented
  Given `dist/che-linux-<arch>` is consumed only by the manual `test-e2e-install-methods` matrix
  When a merge request pipeline runs without that matrix being clicked
  Then the linux cross-build stays off the critical path
  And the automatic unit, e2e and prerelease jobs never wait on it
  And roughly 107 seconds leaves the time-to-first-signal

Scenario: the manual install matrix still gets its binary on demand
  Status: implemented
  Given the linux cross-build now lives in its own manual job
  When an operator clicks both that job and `test-e2e-install-methods`
  Then the matrix consumes the prebuilt binary rather than rebuilding it
  And when the cross-build job was never clicked, the matrix builds the binary itself
  And an unclicked pipeline stays correct without operator knowledge

Scenario: e2e jobs stop waiting eleven minutes to do nine seconds of work
  Status: implemented
  Given `test-e2e-che-{dryrun,run,backup}` really do consume `warm-go`'s built artifacts
  When a merge request pipeline runs
  Then they still wait on `warm-go`, because they need what it builds
  And `warm-go` reaches them much sooner, having shed the work they do not use
  And `test-e2e-che-registry`, which builds what it needs itself, waits on nothing

Scenario: a prerelease arrives sooner without loosening its gates
  Status: implemented
  Given prerelease jobs wait on `test-unit-che` and the automatic che e2e jobs
  When those gates clear earlier under the restructured graph
  Then the prerelease jobs start correspondingly earlier
  And their `needs` list is unchanged
  And a prerelease still never publishes from code that failed its tests
  And this scenario changes nothing asserted in [mr-prereleases.md](mr-prereleases.md)

## Capacity

Scenario: speed is sought where cores are added, not merely shared
  Status: implemented
  Given a 4 vCPU CI node fits exactly two medium job pods, so a third waits on autoscale
  And `go build ./...` already parallelises across the cores its pod gets
  When the pipeline is made faster
  Then the work spreads across more jobs rather than backgrounding within one
  And no job is restructured to run its steps concurrently against cores it does not have
  And `Unschedulable: Insufficient cpu` waits are read as the node-packing described in
    [infra/iac ci-cluster](../../../../infra/iac/spec/unvetted_ai/ci-cluster/GkeRunnerClusterBehavior.md),
    not as a fault in this pipeline

<!-- [<] 🤖🤖 -->
