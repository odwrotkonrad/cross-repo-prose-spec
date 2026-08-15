<!--[>] 🤖🤖 -->
Feature: GKE cluster hosting the Linux GitLab runners

Scenario: the workspace runs its own Linux CI on both architectures
  Status: todo
  Given the applied ci-cluster module provisions a zonal GKE Standard cluster in the `konradodwrot-ci` project
  And an `linux-arm64` node pool (Axion) and a `linux-amd64` node pool, both tainted `ci=true:NoSchedule`
  When a job tagged `gke-linux-arm64` or `gke-linux-amd64` is queued
  Then it runs on the pool matching its architecture
  And no job pod lands on the manager pool

Scenario: a job gets the memory its SaaS equivalent had, at a fraction of the price
  Status: todo
  Given job pods request 1.5 vCPU and 6 GB, against the 2 vCPU / 8 GB the default SaaS runner gave
  When any existing Linux job runs on the cluster
  Then it completes without being OOM-killed
  And CPU, not memory, is what was traded away for cost

Scenario: node overhead is paid once per two jobs, not once per job
  Status: todo
  Given 4 vCPU / 16 GB CI nodes and 1.5 vCPU / 6 GB job pods
  When two jobs for the same architecture are queued
  Then both pods schedule onto one node
  And a second node is created only when a third pod cannot fit

Scenario: a burst of work runs wide, and stops at a known ceiling
  Status: todo
  Given the runner manager caps concurrency at 16 and each CI pool caps `max_node_count` at 8
  When more than 16 jobs are queued at once
  Then at most 16 job pods exist across at most 8 nodes per pool
  And the remaining jobs wait in the queue rather than provisioning further nodes

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

<!--[<] 🤖🤖 -->
