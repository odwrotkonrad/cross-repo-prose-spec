# Milestone 2: Technical Requirements

## Telemetry Collection

- One otel collector runs in the cluster. Session pods send it metrics, traces and logs.
- The collector is the only component holding an egress endpoint for telemetry. A session never
  reaches the destination itself, so the default-deny egress policy stays intact for everything else.
- Its endpoints are supplied to it, and may point at the host. Changing where telemetry goes is a
  change to the collector, never to a session.

## Resource Statistics

- One report, two targets: `session-stats` prints it once, `session-stats-watch` refreshes it. Same
  figures, same arguments, so the watcher is the one-shot on a loop and nothing more.
- Per session, cpu and memory are reported three ways over a window: a central value (average or
  median), the peak, and the current 1-minute average.
- The window is an argument, given as a duration: 1min, 15min, 1h, 2h.
- Current is always the 1-minute average, whatever the window is. The window governs the central value
  and the peak only.
- Disk is a single flat number, the space a session has used. It has no window: only the present size
  matters.
- The report answers whether the resource bounds are set right: a session that never approaches its
  limit is over-provisioned, one that peaks against it is throttled or killed.
- The figures come from the collector this milestone deploys. A window's central value and peak need
  retained history, which is why the report lands here and not in milestone 1.

## Live Configuration Reload

- A configuration change reaches running sessions without recreating their pods.
- Milestone 1 updates configuration by rebuilding an image, which costs every running session its pod.
  This removes that cost: a session keeps running, and its configuration changes underneath it.
- The immutable image stays the source of truth. Live reload is how a change gets to a running
  session, not a second place to define configuration.
- What a running process already read is its own business. The requirement is that the session's
  filesystem holds the new configuration, and anything started afterwards uses it.

## Notification Channel

- Sandboxes get a notification channel for reaching the user asynchronously, for the things a merge
  request cannot carry.
- Four uses:
  - Request a review by a route other than an MR.
  - Send an observation worth reviewing.
  - Request an action or permission the sandbox does not hold.
  - Report a configuration change other sessions would benefit from.
- Asynchronous by design: a session posts and continues. Nothing blocks on the user answering.
- The channel carries messages outward. It is not a way for the user to drive a session, and it grants
  a session no permission it lacked.
