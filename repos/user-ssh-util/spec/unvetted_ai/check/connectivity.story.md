# Feature: Check Platform Connectivity

<!-- [>] 🤖🤖 -->

A read-only command proving every declared key still works against the
platforms it publishes to. Changes nothing, on disk or on any platform.

## As a key owner

Wants to know a key still works before trusting it, and without rotating it.

### Every declared key is checked (implemented)

I want a bare `check` to test every key in config,
so that one command answers whether my setup is healthy.

### An access key is proven by logging in (implemented)

I want an access key tested by authenticating to each platform in its
`publishTo`,
so that the check exercises the thing the key is actually for.

### A signing key is proven by signing (implemented)

I want a signing key tested by signing and verifying a payload rather than by
SSH login, which GitHub refuses to a signing key by design,
so that a healthy signing key never reports as broken.

### A missing keypair is reported, not a crash (implemented)

I want a declared key with nothing on disk to report the path it expected,
so that the reason is obvious without reading a stack trace.

### One key can be checked alone (implemented)

I want `check <name>` to narrow to that key,
so that testing one key costs no platform calls for the others.

## As an operator

Runs the check unattended and needs an exit status to act on.

### A failed check exits non-zero (implemented)

I want any failing check to exit 1, naming how many failed,
so that a script or a scheduled run can react.

### The check never mutates anything (implemented)

I want `check` to publish nothing, revoke nothing and write no state,
so that it is safe to run at any time.

<!-- [<] 🤖🤖 -->
