# Feature: Live configuration reload

<!--[>] 🤖🤖 -->

## As a session user

Works inside a running sandbox. Consumes configuration, never delivers it.

### A configuration change costs no pod and no task (todo)

I want an update landing on the session filesystem with the pod neither
recreated nor restarted, a long agent task running through it,
so that configuration moves without interrupting work.

### Tools started after the update pick it up (todo)

I want a tool launched after the change reading the new configuration,
so that the update takes effect without leaving the session.

### Local edits survive the update (todo)

I want the session's own writes over a configured path left alone,
so that live delivery never overwrites work done in the session.

## As a sandbox operator

Publishes configuration to the fleet, owns the image. Touches no single
session.

### One update reaches every running session (implemented)

I want one update fanned out to all running sessions,
so that the fleet stays uniform with no per-session action.

### The update lands in a running session's home (todo)

I want the rebuilt configuration in every running session's home after the
update,
so that a fleet-wide update changes more than the image a pod boots from.

### The image stays the single source of truth (implemented)

I want a session created after a live change booting with that same
configuration, no session holding configuration the image lacks,
so that live delivery never forks from the image.

<!--[<] 🤖🤖 -->
