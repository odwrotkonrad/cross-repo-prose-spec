# Feature: Resource bounds

<!--[>] 🤖🤖 -->

## As a sandbox operator

Sizes the cluster to the machine. Does not tune session workloads.

### The machine stays usable while sessions run hot (implemented)

I want total session usage held under a cluster-wide cpu and memory cap,
so that no set of sessions can take the host down.

### The cap fits inside the machine (todo)

I want the cluster-wide cap sized within the vm's cpu and memory,
so that the cap is a bound, not a number.

### A runaway session dies instead of the machine (implemented)

I want a pod killed at its memory limit,
so that a leak costs one session, not the cluster.

## As a session user

Creates and works in sessions. Does not size the cluster.

### Starting a session costs almost nothing (implemented)

I want session requests set to a small fraction of the cluster cap,
so that spinning one up is never a capacity decision.

### Idle capacity is there when the work needs it (implemented)

I want a session bursting well past its requests on an idle cluster,
so that a build or test run is not throttled to its reservation.

### A busy neighbour does not block a new session (implemented)

I want a second session scheduled and given at least its requests while the
first consumes all it is allowed,
so that one session can never starve another.

<!--[<] 🤖🤖 -->
