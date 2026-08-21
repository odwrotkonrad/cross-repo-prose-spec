# Feature: Every CI Job Names Its Pod Size

<!-- [>] 🤖🤖 -->

Seven days of runner pod metrics: 2,660 of 3,000 pods ran on the `medium`
tier, 74% of them peaking under a quarter vCPU and 512 MB. Each still
reserved a full vCPU and 3 GB, so a 4 vCPU node held three jobs and validate
jobs queued five to ten minutes on `Insufficient cpu` while the spot pool was
exhausted. The fix is two-sided: the tiers in `cross-repo/infra/iac` carry
requests set from measured usage, and every job tags the tier it needs. The
default alias stays `medium`, so a size is always an explicit choice in
`.gitlab-ci.yml`.

## As a repo maintainer

Writes `.gitlab-ci.yml`. Reads pod metrics only when a job misbehaves.

### Every pod job names its tier (todo)

I want each job that runs a pod carrying a `gke-linux-<arch>-<size>` tag, on
the job, its anchor, or the `default:` block,
so that no job reserves capacity by accident and a reader sees its size where
the job is defined.

### A trigger job names nothing (todo)

I want `trigger:` jobs left untagged,
so that a tag never suggests a pod where none runs.

### Cheap jobs default to small (todo)

I want validate, tag-mint, release, publish, docs and verify jobs on `small`,
so that a job peaking under half a vCPU and 512 MB reserves that, and twenty
of them share the node three used to fill.

### A repo of cheap jobs sizes itself once (todo)

I want a repo whose every pod job is small setting `gke-linux-amd64-small` in
`default.tags` and nothing per job,
so that a job added later is small unless someone says otherwise.

### Compile, test and dind builds stay medium (todo)

I want module builds, unit and coverage runs, e2e harness builds and every
job whose work happens in a `docker:dind` service kept on `medium`,
so that a job peaking up to two vCPU and 3 GB keeps its reservation and a
dind-backed build container keeps the headroom its service has no request for.

### Multi-core release builds and full host applies go big (todo)

I want goreleaser builds and configs' full `apply-linux` on `big`,
so that a job measured above 2.5 vCPU or 4 GB sustained never runs inside a
medium request and within 1 GB of its limit.

### A prebuilt binary runs small (todo)

I want go-modules' e2e jobs that only run a prebuilt `che` on `small`,
so that a job idling at 1 MB stops holding a compile's reservation.

### The size lives on the anchor (todo)

I want the tag on `.release-module`, `.pages-build`, `.test-e2e-che` and the
like, not repeated on each extending job,
so that resizing a family of jobs is one edit.

### A matrix job sizes per arch (todo)

I want arch-matrix jobs tagged `gke-linux-$ARCH-<size>`,
so that both architectures get the same size from one line.

<!-- [<] 🤖🤖 -->
