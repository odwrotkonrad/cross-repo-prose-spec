<!--[>] 🤖🤖 -->
Feature: GKE cluster hosting the Linux GitLab runners

Scenario: the workspace runs its own Linux CI on both architectures
  Status: todo
  Given the applied ci-cluster module provisions a zonal GKE Standard cluster in the `konradodwrot-ci` project
  And an `linux-arm64` node pool (Axion) and a `linux-amd64` node pool, both tainted `ci=true:NoSchedule`
  When a job tagged `gke-linux-arm64` or `gke-linux-amd64` is queued
  Then it runs on the pool matching its architecture
  And no job pod lands on the manager pool

Scenario: an arm64 job runs, rather than waiting three minutes to fail
  Status: todo
  Given GKE taints every Arm node pool `kubernetes.io/arch=arm64:NoSchedule` on its own, whether or not the pool declares it
  And a job pod tolerating only `ci=true` is rejected by that taint
  When a job tagged `gke-linux-arm64` is queued
  Then its pod tolerates both taints and schedules onto an arm64 node
  And the job starts instead of failing with `prepare environment: waiting for pod running: timed out waiting for pod to start`

Scenario: the arm64 taint is visible in the code that causes it
  Status: todo
  Given the arch taint is applied by GKE regardless of what terraform declares
  When the arm64 pool is provisioned
  Then the pool declares that taint itself, alongside `ci=true`
  And a reader learns why arm64 pods need a second toleration without discovering it from a failed job

Scenario: an unschedulable pod does not quietly stall the pool it needs
  Status: todo
  Given the autoscaler adds nodes only for pods a new node could actually run
  And a pod blocked by an untolerated taint would be blocked on a fresh node too
  When such a pod is pending
  Then the autoscaler declines to scale up and says so, rather than growing the pool uselessly
  And the pool stays at zero, so the fault reads as a scheduling error and not a capacity shortage

Scenario: arm64 nodes can be created at all
  Status: todo
  Given C4A (Axion) machines accept `hyperdisk-balanced` and reject `pd-balanced`
  And the amd64 E2 machines predate hyperdisk and stay on `pd-balanced`
  When either CI pool creates a node
  Then each pool uses the disk type its machine family accepts
  And no pool sits permanently at zero because every node creation was rejected

Scenario: a job gets the memory its SaaS equivalent had, at a fraction of the price
  Status: todo
  Given job pods request 1 vCPU and 6 GB, against the 2 vCPU / 8 GB the default SaaS runner gave
  When any existing Linux job runs on the cluster
  Then it completes without being OOM-killed
  And CPU, not memory, is what was traded away for cost

Scenario: node overhead is amortised across several jobs, not paid per job
  Status: todo
  Given 4 vCPU / 16 GB CI nodes and medium job pods whose requests are half their limits
  When several medium jobs for the same architecture are queued
  Then more than one pod schedules onto each node
  And a new node is created only when the next pod's request no longer fits

Scenario: a job reserves what it uses, not what it might peak at
  Status: todo
  Given a node offers roughly 3.6 vCPU and 12 GB once daemonsets take their share
  And a medium job's cpu request is what decides how many fit, memory allowing more
  When medium jobs are queued
  Then three pack onto a node rather than two
  And the same burst is served by a third fewer nodes
  And the cpu request stays a reservation, not a cap, so a job still bursts into idle capacity

Scenario: a job asks for the size it needs, by name
  Status: todo
  Given runners offering `small`, `medium` and `big` pod sizes per architecture
  When a job is tagged for one of those sizes
  Then its pod is created with that size's cpu and memory requests
  And a job that names no size gets `medium`, the default that matches the SaaS runner it replaces

Scenario: nodes pack to their real usage, not to worst-case reservations
  Status: todo
  Given each size declares a memory request that reserves capacity and a memory limit that caps it
  And the request is half the limit, so a node's pods may claim up to twice its capacity
  When jobs are scheduled
  Then scheduling counts the requests, fitting twice as many pods as the limits alone would allow

Scenario: a job that runs out of memory fails fast instead of limping
  Status: todo
  Given job pods carry a memory limit
  When a job exceeds it, or its node comes under memory pressure
  Then the pod is killed or evicted promptly and the job fails visibly
  And no job is left running far past its normal duration because it was starved

Scenario: a job is never made slower than the capacity it could have used
  Status: todo
  Given job pods declare a cpu request but no cpu limit
  When a job could use more cpu than it reserved and the node has spare cycles
  Then it uses them rather than being throttled to its request
  And when the node is busy, cpu is shared in proportion to what each pod reserved

Scenario: bursty jobs use idle capacity instead of reserving it
  Status: todo
  Given CI jobs that are busy in short spikes and near-idle between them
  When one pod bursts above its request while its node neighbour is idle
  Then it consumes the spare capacity up to its limit
  And it is not billed for that headroom while idle

Scenario: cheap jobs stop paying for capacity they never use
  Status: todo
  Given lint, render and validate jobs that need far less than a build
  When they run as `small` pods
  Then several of them pack onto a single node
  And they no longer reserve the memory a build would

Scenario: a heavy job gets room without upsizing every other job
  Status: todo
  Given a job that exhausts the default size, for example a dind image build or the e2e matrix
  When it runs as a `big` pod
  Then it receives the larger cpu and memory requests
  And the sizes available to other jobs are unchanged

Scenario: a burst of work runs wide, and stops at a known ceiling
  Status: todo
  Given the runner manager caps concurrency at 16 and each CI pool caps `max_node_count` at 8
  When more than 16 jobs are queued at once
  Then at most 16 job pods exist across at most 8 nodes per pool
  And the remaining jobs wait in the queue rather than provisioning further nodes

Scenario: denser packing lowers the bill without raising the ceiling
  Status: todo
  Given the node cap and the concurrency cap are the two ceilings on spend
  When more job pods fit on each node
  Then the concurrency cap is what binds first, and the node cap gains headroom
  And the worst-case node count falls while the worst-case job count is unchanged
  And the project's cpu quota still covers both pools at their cap

Scenario: an idle cluster costs nothing beyond its floor
  Status: todo
  Given both CI node pools autoscale with `min_node_count = 0`
  When no job has run for the configured idle window
  Then both CI pools hold zero nodes
  And the only running node is the single always-on manager node

Scenario: capacity is released promptly when work stops
  Status: todo
  Given the autoscaler is tuned to remove unneeded nodes after roughly two minutes
  When the last job on a node finishes
  Then that node is removed shortly after, not held for the default ten minutes
  And the cost of the next cold start is accepted in exchange

Scenario: a queued job wakes the cluster without human action
  Status: todo
  Given both CI pools are scaled to zero
  And the runner manager pod runs on the always-on manager pool
  When a job is queued for a `gke-linux-*` tag
  Then the manager receives it and the matching pool scales up
  And the job starts without anyone touching the cluster

Scenario: running capacity tracks the queue with no extra scaling component
  Status: todo
  Given one runner manager creating a job pod per queued job, up to its concurrency cap
  And the cluster autoscaler adding nodes for pods that cannot be scheduled
  When the queue grows and then drains
  Then pod count follows queue depth and node count follows pod count
  And no separate queue-polling autoscaler is deployed to achieve it

Scenario: one manager serves every architecture and size
  Status: todo
  Given a single runner manager deployment holding one runner entry per architecture and size
  When jobs for different architectures and sizes are queued together
  Then the one manager dispatches all of them, each to the pool and pod size its entry declares
  And adding a size or architecture adds an entry, not another manager to run and pay for

Scenario: CI compute is billed at spot prices
  Status: todo
  Given both CI node pools are provisioned as spot VMs
  When nodes are created for a queued job
  Then they are spot instances

Scenario: preemption never takes out the thing that dispatches work
  Status: todo
  Given only the worker pools (`linux-arm64`, `linux-amd64`) use spot capacity
  And the `manager` pool that hosts the runner manager pod uses standard on-demand capacity
  When spot nodes are preempted, including all of them at once
  Then the manager pod keeps running and keeps receiving queued jobs
  And it schedules replacement job pods once spot capacity returns

Scenario: the cluster sits where spot capacity is deep and prices are low
  Status: todo
  Given the cluster is placed in `us-central1`, a large long-established region at GCP's lowest price tier
  And a zonal cluster has no second zone to fall back on when spot capacity runs out
  When nodes are requested for either architecture
  Then the chosen region carries both the machine types and the spot capacity to satisfy them
  And moving region is a variable change, not a rewrite

Scenario: a preempted job fails loudly instead of corrupting a release
  Status: todo
  Given a job running on a spot node
  When the node is preempted mid-job
  Then the job fails and is retried or reported, never silently marked successful
  And release-publishing jobs do not run on preemptible capacity

Scenario: docker-in-docker jobs keep working after the move
  Status: todo
  Given jobs in `infra/oci-images` and `go-modules` that build images with dind
  When they run on a `gke-linux-*` runner
  Then privileged containers are available to the job pod
  And the produced images match those built on the previous runner

Scenario: the runner authenticates without a long-lived key on disk
  Status: todo
  Given the runner registration token lives in Secrets Manager in the `konradodwrot-ci` project
  And the runner's GCP service account is bound through Workload Identity
  When the manager pod authenticates to GitLab and to GCP
  Then it reads the token via the bound identity
  And no service account key file exists in the cluster

Scenario: a compromised runner reaches nothing beyond CI
  Status: todo
  Given the runner service account holds only the roles its jobs need in the `konradodwrot-ci` project
  When a job attempts to read the sandbox auth project, `restricted`, or any other project
  Then the request is denied

Scenario: reaching the node's identity yields almost nothing
  Status: todo
  Given nodes run as a dedicated service account holding only logging, monitoring and image-pull roles
  And not the default compute service account, which carries project Editor
  When a privileged job container reaches the instance metadata server
  Then the identity it obtains cannot read secrets, alter the cluster, or create resources

Scenario: a runaway job matrix cannot spin up unbounded nodes
  Status: todo
  Given each CI pool caps `max_node_count` and the runner caps concurrency
  When more jobs are queued than the caps allow
  Then the extra jobs queue instead of provisioning nodes past the cap
  And the cluster's worst-case hourly cost stays bounded and known

Scenario: cluster spend is legible without filtering
  Status: todo
  Given the cluster lives in its own `konradodwrot-ci` project
  When anyone reads the GCP billing report grouped by project
  Then CI cost appears as one figure, separate from sandbox and other spend

Scenario: workspace-wide CI toggles are declared once, in terraform
  Status: todo
  Given `ENABLE_DARWIN_CI` is a group variable on `konradodwrot` owned by the gitlab module
  When it is applied
  Then every project under the group reads it without its own declaration
  And it is unprotected and unmasked, being a behavior flag rather than a secret

Scenario: the move is provable one job at a time
  Status: todo
  Given runners registered under new tags while existing jobs keep their current tags
  When a single job is repointed to a `gke-linux-*` tag
  Then only that job moves
  And reverting is a tag change in `.gitlab-ci.yml`, with no infrastructure change

Scenario: a packed node keeps egress for every pod it hosts
  Status: todo
  Given private nodes reach the registry and the GitLab API only through the Cloud NAT
  And a node hosts many pods at once, each opening its own connections
  When several jobs pull images and talk to GitLab from the same node
  Then the NAT has ports for all of them, rather than a fixed per-node share sized for one pod
  And no job fails preparing its environment with a timeout dialling gitlab.com

<!--[<] 🤖🤖 -->
