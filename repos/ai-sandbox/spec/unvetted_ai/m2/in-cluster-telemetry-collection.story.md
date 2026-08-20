# Feature: In-cluster telemetry collection

<!--[>] 🤖🤖 -->

## As a sandbox operator

Runs the kind cluster and watches what sessions emit. Owns the collector and
its endpoints, never edits a session.

### Metrics, traces and logs arrive from every session (todo)

I want an in-cluster collector receiving all three signals from session pods,
so that session behaviour is observable without reaching into a pod.

### Telemetry lands wherever the endpoint is set, host included (todo)

I want the collector forwarding to the endpoints it is given, one on the
cluster host included,
so that the backend is a config choice, not a cluster rebuild.

### Each signal names its source session (todo)

I want telemetry carrying the name of the session that emitted it,
so that concurrent sessions stay distinguishable at the endpoint.

### A destination change costs no session downtime (todo)

I want a new endpoint applied by reconfiguring the collector alone,
so that moving telemetry changes or restarts no session.

## As a session user

Works inside a sandbox. Emits telemetry, holds no egress and no collector
config.

### Confinement holds while telemetry still gets out (todo)

I want default-deny egress blocking a session from reaching the endpoint
directly, the collector the only path out,
so that observability does not widen the sandbox.

### A broken telemetry backend never breaks the work (todo)

I want a session running on when the endpoint is unreachable, the failure the
collector's to report,
so that an observability outage stays out of the session.

<!--[<] 🤖🤖 -->
