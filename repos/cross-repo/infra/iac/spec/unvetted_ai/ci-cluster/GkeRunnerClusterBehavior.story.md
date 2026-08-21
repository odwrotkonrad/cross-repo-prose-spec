# Feature: GKE cluster hosting the Linux GitLab runners

<!-- [>] 🤖🤖 -->

## As a CI maintainer

Tags jobs and reads their logs. Does not provision nodes.

### Linux CI on both architectures, self-hosted (implemented)

I want `linux-arm64` (Axion) and `linux-amd64` node pools tainted
`ci=true:NoSchedule` in a zonal GKE Standard cluster in the CI project,
so that a job tagged `gke-linux-arm64` or `gke-linux-amd64` lands on the pool
for its architecture, never on the manager pool.

### An arm64 job runs instead of timing out (implemented)

I want job pods tolerating both `ci=true` and the
`kubernetes.io/arch=arm64:NoSchedule` taint GKE adds itself,
so that the job starts instead of failing with `prepare environment: waiting
for pod running: timed out waiting for pod to start`.

### A job asks for its size by name (implemented)

I want `small`, `medium` and `big` pod sizes per architecture, default
`medium`,
so that a tagged job gets that size's cpu and memory requests and an untagged
one matches the SaaS runner it replaces.

### The SaaS memory budget survives the move (implemented)

I want medium job pods at a 6 GB memory limit, against the SaaS 2 vCPU / 8 GB,
so that existing jobs finish without OOM kills. Cpu was traded for cost.

### Cheap jobs stop paying for a build's capacity (implemented)

I want a `small` size for lint, render and validate jobs,
so that several pack onto one node instead of each reserving build-sized
memory.

### Every validate job runs small (todo)

I want each repo's precommit validate job tagged `gke-linux-amd64-small`, as
iac's already is,
so that no lint job reserves a build's memory.

### A heavy job gets room without upsizing the rest (implemented)

I want a `big` size, used by the goreleaser builds,
so that a heavy job gets larger requests and every other size stays put.

### A full host apply takes the big size (todo)

I want configs' `apply-linux` tagged `gke-linux-$ARCH-big`,
so that a job measured at 3.7 vCPU and 4.9 GB stops running inside a medium
pod's request, 1 GB under its limit.

### Dind builds stay medium (todo)

I want the oci-images builds and the go-modules e2e install matrix on the
medium size,
so that a build container idling at 0.01 vCPU beside a `docker:dind` service
with no request of its own reserves no more than it uses.

### A job is never throttled below available capacity (implemented)

I want a cpu request and no cpu limit on job pods,
so that a job bursts into idle cycles and, on a busy node, gets cpu in
proportion to its reservation.

### An out-of-memory job fails fast (implemented)

I want a memory limit on job pods,
so that exceeding it kills or evicts the pod at once instead of leaving a
starved job limping far past its normal duration.

### Docker-in-docker jobs keep working (implemented)

I want privileged containers available to job pods on `gke-linux-*` runners,
so that `infra/oci-images` and `go-modules` builds produce the same images as
on the previous runner.

### The move is provable one job at a time (implemented)

I want runners registered under new tags while existing jobs keep theirs,
so that repointing one job moves only that job and reverting is a tag change
in `.gitlab-ci.yml`.

### A job never waits on an image its node already holds (implemented)

I want the runner helper image already in a busy node's image cache,
so that no job fails `prepare environment` on a pull that timed out under
overcommitted cpu.

### A packed node keeps egress for every pod (implemented)

I want Cloud NAT ports allocated for all of a node's pods, not a fixed
per-node share sized for one,
so that no job fails `prepare environment` on a timeout dialling gitlab.com.

## As an infra operator

Applies the ci-cluster module. Owns pools, taints, identity and caps.

### The arm64 taint is visible in the code that causes it (todo)

I want the arm64 pool to declare the arch taint itself, beside `ci=true`,
so that a reader sees why arm64 pods need a second toleration instead of
learning it from a failed job.

### An untolerated pod reads as a scheduling error (implemented)

I want the autoscaler to refuse scaling for a pod a fresh node could not run,
and say so,
so that the pool stays at zero and the fault does not look like a capacity
shortage.

### Arm64 nodes can be created at all (implemented)

I want `hyperdisk-balanced` on the C4A pool and `pd-balanced` on the amd64 E2
pool,
so that each family gets a disk type it accepts and no pool sits at zero
forever on rejected node creations.

### Node overhead is amortised across jobs (implemented)

I want 4 vCPU / 16 GB nodes and requests at half their limits,
so that several medium pods share a node and a new node appears only when the
next request no longer fits.

### Three medium pods per node, not two (implemented)

I want the medium cpu request set to what a job uses, not its peak, against
roughly 3.6 vCPU and 12 GB usable per node,
so that a burst needs a third fewer nodes while the request stays a
reservation, not a cap.

### Requests follow measured usage per tier (implemented)

I want each size's cpu and memory request set from the p75-p90 of seven days
of pod metrics for jobs on that tier (small 150m / 384Mi, medium 750m / 2Gi,
big 2500m / 8Gi),
so that a validate job's node fits twenty small pods instead of three, and a
pending pod on `Insufficient cpu` stops being the normal case.

### Memory limits sit above the observed maximum (implemented)

I want each tier's memory limit above the largest peak measured on it (small
1Gi, medium 6Gi, big 14Gi),
so that a job at its known worst case finishes instead of dying a few hundred
MB under a limit set before it was measured.

### The default alias never downsizes a job (implemented)

I want `gke-linux-<arch>` still resolving to `medium`,
so that a job nobody has sized keeps its request and every downsize is an
explicit tag in `.gitlab-ci.yml`.

### Scheduling counts requests, not worst-case limits (implemented)

I want each size's memory request below its limit, on measured usage,
so that scheduling fits more pods than the limits alone would allow.

### Bursty jobs use idle capacity instead of reserving it (implemented)

I want a pod bursting above its request into an idle neighbour's capacity, up
to its limit,
so that spiky CI jobs are not billed for idle headroom.

### A burst runs wide and stops at a known ceiling (implemented)

I want concurrency capped at 124 and `max_node_count` at 6 per pool, 2 per
fallback pool,
so that excess jobs queue instead of provisioning more nodes.

### Each job size has its own concurrency cap (implemented)

I want a per-size `limit` on every `[[runners]]` entry, 2 big, 12 medium, 48
small per arch, sized so worst-case packing fits the 8-node arch ceiling,
so that a burst of big jobs cannot hold every slot, and small jobs run as wide
as the nodes allow instead of sharing one global number sized for big ones.

### The primary pools reach eight nodes once quota allows (todo)

I want `max_node_count` at 8 on `linux-arm64` and `linux-amd64`, cpu quota
raised to fit,
so that a wide burst runs at the intended ceiling, not the one current quota
admits.

### An idle cluster costs only its floor (implemented)

I want both CI pools autoscaling from `min_node_count = 0`,
so that after the idle window the only running node is the always-on manager
node.

### Capacity is released promptly (implemented)

I want the autoscaler on the optimize-utilization profile,
so that a finished node goes sooner than under the default profile, at the
price of the next cold start.

### A queued job wakes the cluster unattended (implemented)

I want the runner manager on the always-on pool receiving `gke-linux-*` jobs
while both CI pools sit at zero,
so that the matching pool scales up and the job starts with nobody touching
the cluster.

### Capacity tracks the queue with no extra component (implemented)

I want one runner manager creating a pod per queued job and the cluster
autoscaler adding nodes for unschedulable pods,
so that pod count follows queue depth and node count follows pod count, with
no queue-polling autoscaler.

### One manager serves every architecture and size (implemented)

I want one manager deployment holding one runner entry per architecture and
size,
so that a new size or architecture is an entry, not another manager to run and
pay for.

### CI compute is billed at spot prices (implemented)

I want both CI node pools provisioned as spot VMs,
so that nodes created for queued jobs are spot instances.

### Preemption never takes out the dispatcher (implemented)

I want the `manager` pool on on-demand capacity, only the CI pools on spot,
so that the manager keeps receiving jobs through a full preemption and
schedules replacements when spot returns.

### The cluster sits where spot capacity is deep (implemented)

I want placement in `us-central1`, a large long-established region at the
lowest price tier (a zonal cluster has no fallback zone),
so that both machine types and their spot capacity are available and moving
region is a variable change.

### A preempted job fails loudly (implemented)

I want a job preempted mid-run to fail and be retried or reported,
so that it is never silently marked successful.

### A release never runs on preemptible capacity (todo)

I want release-publishing jobs scheduled on an on-demand pool,
so that a preemption never cuts a push halfway.

### The runner authenticates without a key on disk (implemented)

I want the runner service account bound through Workload Identity,
so that no service account key file exists in the cluster.

### The runner token never sits in helm values (todo)

I want the runner token in Secrets Manager in the CI project, read by the
manager through its bound identity,
so that neither terraform state nor the chart release carries a GitLab
credential.

### A compromised runner reaches nothing beyond CI (implemented)

I want the runner service account holding only the roles its jobs need in the
CI project,
so that reads of the sandbox auth project or any other project are denied.

### The node identity yields almost nothing (implemented)

I want nodes running as a dedicated service account with only logging,
monitoring and image-pull roles, not the default compute account with Editor,
so that a privileged container reaching the metadata server gets an identity
that cannot read secrets, alter the cluster or create resources.

### Workspace CI toggles are declared once (implemented)

I want `GRP_KO_VAR_ENABLE_DARWIN_CI` as a group variable on `konradodwrot`
owned by the gitlab module, unprotected and unmasked,
so that every project reads it without declaring it. It is a behavior flag,
not a secret.

## As an account owner watching spend

Reads the billing report. Sets the ceilings, not the pod sizes.

### Denser packing lowers the bill without raising the ceiling (implemented)

I want more job pods per node under the fixed node and concurrency caps,
so that concurrency binds first, worst-case node count falls, worst-case job
count holds, and the project cpu quota still covers both pools at cap.

### A runaway matrix cannot spin up unbounded nodes (implemented)

I want jobs beyond `max_node_count` and the concurrency cap to queue,
so that worst-case hourly cost stays bounded and known.

### Cluster spend is legible without filtering (implemented)

I want the cluster in its own project,
so that a billing report grouped by project shows CI cost as one figure, apart
from sandbox spend.

### CI spend is named for what it is (todo)

I want the CI project named `konradodwrot-ci`, not `staging`,
so that the billing line reads as CI without a lookup.

<!-- [<] 🤖🤖 -->
