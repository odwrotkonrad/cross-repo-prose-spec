# Feature: Live configuration reload

<!--[>] 🤖🤖 -->

## As a session user

Works inside a running sandbox. Consumes configuration, does not deliver it.

### A configuration change costs no pod and no task (todo)

I want an update to land on the session filesystem with the pod neither
recreated nor restarted, a long agent task running through it,
so that configuration moves without interrupting work.

### Tools started after the update pick it up (todo)

I want a tool launched after the change to behave by the new configuration,
so that the update takes effect without leaving the session.

### Local edits survive the update (todo)

I want a session's own writes over a configured path left in place,
so that live delivery never overwrites work done in the session.

## As a sandbox operator

Publishes configuration to the fleet and owns the image. Does not touch
individual sessions.

### One update reaches every running session (todo)

I want a single configuration update applied across all running sessions,
so that the fleet stays uniform without per-session action.

### The image stays the single source of truth (todo)

I want a session created after a live change to boot with that same
configuration, no session holding configuration the image does not define,
so that live delivery never forks from the image.

<!--[<] 🤖🤖 -->
