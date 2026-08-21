# Feature: Configuration as an image layer

<!--[>] 🤖🤖 -->

## As a session user

Writes freely inside the session. Manages no storage.

### Everything is writable (tested)

I want writes to any path the configuration image provides succeeding,
so that no path is off limits mid-task.

### What must outlive the pod does (tested)

I want the workspace intact after a stop and start,
so that persistence is deliberate.

### Scratch paths start clean (todo)

I want scratch paths reset to the image's content after a stop and start,
so that only the workspace carries state across restarts.

## As a sandbox operator

Owns how configuration reaches a pod. Does not use the sessions.

### Nothing is mounted from the host (implemented)

I want a pod's user configuration coming from the configuration image, no host
directory mounted,
so that the host filesystem is outside the sandbox.

### One session's writes stay its own (implemented)

I want other sessions still reading the image's content after one overwrites
it, and new sessions booting from the image,
so that sessions cannot contaminate each other.

### Many sessions cost one copy (todo)

I want the image stored once per node, each session costing only what it
wrote,
so that session count is not a storage decision.

<!--[<] 🤖🤖 -->
