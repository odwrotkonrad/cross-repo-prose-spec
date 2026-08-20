# Feature: GCP least privilege

<!--[>] 🤖🤖 -->

## As a security owner

Scopes the service account. Does not use it.

### Reads are bounded to two projects (implemented)

I want reads succeeding in the secrets and iac projects,
so that the sandbox reaches what its flows read.

### No other project is readable (todo)

I want a read in any project beyond those two refused,
so that the blast radius is named, not inherited.

### Nothing in gcp can be changed from a sandbox (implemented)

I want a modification attempt in either project refused,
so that read-only is enforced, not conventional.

### Access exists only where the image put it (implemented)

I want a session created without the configuration image unable to authenticate
to gcp,
so that gcp access is never the default.

## As a session user

Uses gcp from the session. Does not handle credentials.

### GCP works without being handed a credential (implemented)

I want the sandbox service account baked into the configuration image and
authenticating at session start,
so that no secret passes through session start.

### Every session authenticates identically (implemented)

I want two sessions on the same configuration image presenting the same service
account,
so that behaviour never depends on which session runs the work.

<!--[<] 🤖🤖 -->
