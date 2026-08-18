# Feature: Resource bounds

<!--[>] 🤖🤖 -->

## As a sandbox operator

Sizes the cluster against the machine. Does not tune a session's workload.

### The machine stays usable while sessions run hot (todo)

I want combined session usage held inside the cluster-wide cpu and memory cap,
so that no set of sessions can take the host down with it.

### A runaway session dies instead of the machine (todo)

I want a pod crossing its memory limit stopped at that limit,
so that a leak costs one session, not the cluster.

## As a session user

Creates and works in sessions. Does not size the cluster.

### Starting a session costs almost nothing (todo)

I want session requests set to a small fraction of the cluster cap,
so that spinning one up is never a capacity decision.

### Idle capacity is there when the work needs it (todo)

I want a session bursting well beyond its requests on an idle cluster,
so that a build or a test run is not throttled to its reservation.

### A busy neighbour does not block a new session (todo)

I want a second session scheduling and receiving at least its requests while the
first consumes everything it is allowed,
so that one session can never starve another.

<!--[<] 🤖🤖 -->
