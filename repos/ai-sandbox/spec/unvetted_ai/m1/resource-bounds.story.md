# Feature: Resource bounds

<!--[>] 🤖🤖 -->

## As a sandbox operator

Sizes the cluster against the machine. Does not tune a session's workload.

### The machine stays usable while sessions run hot (implemented)

I want combined session usage held inside a cluster-wide cpu and memory cap,
so that no set of sessions can take the host down with it.

### The cap fits inside the machine (todo)

I want the cluster-wide limits cap sized within the vm's cpu and memory,
so that the cap is a bound and not a number.

### A runaway session dies instead of the machine (implemented)

I want a pod crossing its memory limit stopped at that limit,
so that a leak costs one session, not the cluster.

## As a session user

Creates and works in sessions. Does not size the cluster.

### Starting a session costs almost nothing (implemented)

I want session requests set to a small fraction of the cluster cap,
so that spinning one up is never a capacity decision.

### Idle capacity is there when the work needs it (implemented)

I want a session bursting well beyond its requests on an idle cluster,
so that a build or a test run is not throttled to its reservation.

### A busy neighbour does not block a new session (implemented)

I want a second session scheduling and receiving at least its requests while the
first consumes everything it is allowed,
so that one session can never starve another.

<!--[<] 🤖🤖 -->
