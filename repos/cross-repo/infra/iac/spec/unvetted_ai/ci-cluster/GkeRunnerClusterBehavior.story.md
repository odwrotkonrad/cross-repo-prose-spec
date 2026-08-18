# Feature: GKE cluster hosting the Linux GitLab runners

<!-- [>] 🤖🤖 -->

## As a CI maintainer

Tags jobs and reads their logs. Does not provision nodes.

### Linux CI on both architectures, self-hosted (todo)

I want `linux-arm64` (Axion) and `linux-amd64` node pools tainted
`ci=true:NoSchedule` in a zonal GKE Standard cluster in `konradodwrot-ci`,
so that a job tagged `gke-linux-arm64` or `gke-linux-amd64` runs on the pool
matching its architecture and never on the manager pool.

### An arm64 job runs instead of timing out (todo)

I want job pods tolerating both `ci=true` and the
`kubernetes.io/arch=arm64:NoSchedule` taint GKE applies on its own,
so that the job starts rather than failing with `prepare environment: waiting
for pod running: timed out waiting for pod to start`.

### A job asks for its size by name (todo)

I want runners offering `small`, `medium` and `big` pod sizes per architecture,
defaulting to `medium`,
so that a tagged job gets that size's cpu and memory requests and an untagged
one matches the SaaS runner it replaces.

### The SaaS memory budget survives the move (todo)

I want job pods requesting 1 vCPU and 6 GB against the SaaS 2 vCPU / 8 GB,
so that existing jobs complete without OOM kills, cpu being what was traded for
cost.

### Cheap jobs stop paying for a build's capacity (todo)

I want lint, render and validate jobs running as `small` pods,
so that several pack onto one node instead of reserving build-sized memory.

### A heavy job gets room without upsizing the rest (todo)

I want a dind image build or e2e matrix run as a `big` pod,
so that it receives larger requests while the sizes other jobs use are
unchanged.

### A job is never throttled below available capacity (todo)

I want a cpu request and no cpu limit on job pods,
so that a job bursts into idle node cycles and, on a busy node, shares cpu in
proportion to what it reserved.

### An out-of-memory job fails fast (todo)

I want a memory limit on job pods,
so that exceeding it kills or evicts the pod promptly instead of leaving a
starved job limping far past its normal duration.

### Docker-in-docker jobs keep working (todo)

I want privileged containers available to job pods on `gke-linux-*` runners,
so that `infra/oci-images` and `go-modules` builds produce images matching the
previous runner.

### The move is provable one job at a time (todo)

I want runners registered under new tags while existing jobs keep theirs,
so that repointing a single job moves only that job and reverting is a tag
change in `.gitlab-ci.yml`.

### A job never waits on an image its node already holds (implemented)

I want the runner helper image already in a busy node's image cache,
so that no job fails preparing its environment because a pull timed out under
overcommitted cpu.

### A packed node keeps egress for every pod (implemented)

I want Cloud NAT ports allocated for all of a node's pods, not a fixed
per-node share sized for one,
so that no job fails preparing its environment with a timeout dialling
gitlab.com.

## As an infra operator

Applies the ci-cluster module. Owns pools, taints, identity and caps.

### The arm64 taint is visible in the code that causes it (todo)

I want the arm64 pool to declare the arch taint itself alongside `ci=true`,
so that a reader learns why arm64 pods need a second toleration without
discovering it from a failed job.

### An untolerated pod reads as a scheduling error (todo)

I want the autoscaler to decline scaling for a pod a fresh node could not run,
and say so,
so that the pool stays at zero and the fault does not read as a capacity
shortage.

### Arm64 nodes can be created at all (todo)

I want `hyperdisk-balanced` on the C4A pool and `pd-balanced` on the amd64 E2
pool,
so that each family gets the disk type it accepts and no pool sits permanently
at zero from rejected node creations.

### Node overhead is amortised across jobs (todo)

I want 4 vCPU / 16 GB nodes and requests at half their limits,
so that several medium pods share a node and a new node appears only when the
next request no longer fits.

### Three medium pods per node, not two (todo)

I want the medium cpu request set to what a job uses rather than its peak,
against roughly 3.6 vCPU and 12 GB usable per node,
so that a burst is served by a third fewer nodes while the request stays a
reservation, not a cap.

### Scheduling counts requests, not worst-case limits (todo)

I want each size's memory request at half its limit,
so that scheduling fits twice as many pods as the limits alone would allow.

### Bursty jobs use idle capacity instead of reserving it (todo)

I want a pod bursting above its request into an idle neighbour's capacity, up
to its limit,
so that spiky CI jobs are not billed for headroom while idle.

### A burst runs wide and stops at a known ceiling (todo)

I want concurrency capped at 16 and `max_node_count` at 8 per pool,
so that excess jobs queue rather than provisioning further nodes.

### An idle cluster costs only its floor (todo)

I want both CI pools autoscaling from `min_node_count = 0`,
so that after the idle window the only running node is the single always-on
manager node.

### Capacity is released promptly (todo)

I want the autoscaler tuned to remove unneeded nodes after roughly two minutes,
so that a finished node goes rather than being held for the default ten, the
next cold start accepted in exchange.

### A queued job wakes the cluster unattended (todo)

I want the runner manager on the always-on pool receiving `gke-linux-*` jobs
while both CI pools sit at zero,
so that the matching pool scales up and the job starts without anyone touching
the cluster.

### Capacity tracks the queue with no extra component (todo)

I want one runner manager creating a pod per queued job and the cluster
autoscaler adding nodes for unschedulable pods,
so that pod count follows queue depth and node count follows pod count, with no
queue-polling autoscaler deployed.

### One manager serves every architecture and size (todo)

I want a single manager deployment holding one runner entry per architecture
and size,
so that adding a size or architecture adds an entry, not another manager to run
and pay for.

### CI compute is billed at spot prices (todo)

I want both CI node pools provisioned as spot VMs,
so that nodes created for queued jobs are spot instances.

### Preemption never takes out the dispatcher (todo)

I want the `manager` pool on standard on-demand capacity while only
`linux-arm64` and `linux-amd64` use spot,
so that the manager keeps receiving jobs through a full preemption and
schedules replacement pods when spot returns.

### The cluster sits where spot capacity is deep (todo)

I want placement in `us-central1`, a large long-established region at the
lowest price tier, a zonal cluster having no fallback zone,
so that both machine types and their spot capacity are available and moving
region is a variable change.

### A preempted job fails loudly (todo)

I want a job preempted mid-run to fail and be retried or reported,
so that it is never silently marked successful, release-publishing jobs staying
off preemptible capacity.

### The runner authenticates without a key on disk (todo)

I want the registration token in Secrets Manager in `konradodwrot-ci` and the
runner service account bound through Workload Identity,
so that the manager reads the token via the bound identity and no service
account key file exists in the cluster.

### A compromised runner reaches nothing beyond CI (todo)

I want the runner service account holding only the roles its jobs need in
`konradodwrot-ci`,
so that reads of the sandbox auth project, `restricted`, or any other project
are denied.

### The node identity yields almost nothing (todo)

I want nodes running as a dedicated service account with only logging,
monitoring and image-pull roles, not the default compute account carrying
Editor,
so that a privileged container reaching the metadata server obtains an identity
that cannot read secrets, alter the cluster, or create resources.

### Workspace CI toggles are declared once (todo)

I want `ENABLE_DARWIN_CI` as a group variable on `konradodwrot` owned by the
gitlab module, unprotected and unmasked,
so that every project reads it without its own declaration, it being a behavior
flag rather than a secret.

## As an account owner watching spend

Reads the billing report. Sets the ceilings, not the pod sizes.

### Denser packing lowers the bill without raising the ceiling (todo)

I want more job pods per node against the fixed node and concurrency caps,
so that concurrency binds first, worst-case node count falls, worst-case job
count is unchanged, and the project cpu quota still covers both pools at cap.

### A runaway matrix cannot spin up unbounded nodes (todo)

I want jobs beyond `max_node_count` and the concurrency cap to queue,
so that the cluster's worst-case hourly cost stays bounded and known.

### Cluster spend is legible without filtering (todo)

I want the cluster in its own `konradodwrot-ci` project,
so that a billing report grouped by project shows CI cost as one figure,
separate from sandbox spend.

<!-- [<] 🤖🤖 -->
