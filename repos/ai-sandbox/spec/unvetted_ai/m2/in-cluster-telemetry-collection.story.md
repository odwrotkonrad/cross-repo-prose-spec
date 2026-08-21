# Feature: In-cluster telemetry collection

<!--[>] 🤖🤖 -->

## As a sandbox operator

Runs the kind cluster, watches what sessions emit. Owns the collector and its
endpoints, never edits a session.

### Metrics, traces and logs arrive from every session (todo)

I want one in-cluster collector receiving all three signals from session pods,
so that sessions are observable without an exec into a pod.

### Telemetry lands wherever the endpoint is set, host included (todo)

I want the collector forwarding to whatever endpoints it is given, the cluster
host among them,
so that the backend is a config choice, not a cluster rebuild.

### Each signal names its source session (todo)

I want telemetry tagged with the emitting session's name,
so that concurrent sessions stay apart at the endpoint.

### A destination change costs no session downtime (todo)

I want a new endpoint applied by reconfiguring the collector alone,
so that moving telemetry restarts no session.

## As a session user

Works inside a sandbox. Emits telemetry, holds no egress and no collector
config.

### Confinement holds while telemetry still gets out (todo)

I want default-deny egress blocking the session from the endpoint, the
collector the only path out,
so that observability does not widen the sandbox.

### A broken telemetry backend never breaks the work (todo)

I want the session running on when the endpoint is unreachable, the failure
reported by the collector,
so that an observability outage stays out of the session.

<!--[<] 🤖🤖 -->
