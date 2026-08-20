# Feature: Host boundary

<!--[>] 🤖🤖 -->

## As a security owner

Fixes the direction of trust. Does not operate sessions.

### Escaping a session gains no foothold on the machine (implemented)

I want a session denied on every host port,
so that the host is not reachable from inside the sandbox.

### A host port is closed until a rule opens it (implemented)

I want an unnamed host port denied,
so that the host is closed by default.

### An admitted host port is reachable (todo)

I want a rule naming one host port making it reachable,
so that exposure is a deliberate act.

### Opening one port opens nothing else (todo)

I want a rule admitting one host port leaving every other port denied,
so that a grant cannot be widened by accident.

## As a session user

Drives a session from the host terminal. Does not configure the policy.

### The session is still reachable to work in (tested)

I want the host opening a shell into a running session pod,
so that a one-way boundary does not cost the workflow.

<!--[<] 🤖🤖 -->
