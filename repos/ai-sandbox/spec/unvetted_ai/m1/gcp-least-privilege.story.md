# Feature: GCP least privilege

<!--[>] 🤖🤖 -->

## As a security owner

Scopes the service account. Does not use it.

### Reads are bounded to two projects (todo)

I want reads succeeding in the secrets and iac projects and refused in any
other,
so that the blast radius is named, not inherited.

### Nothing in gcp can be changed from a sandbox (todo)

I want a modification attempt in either project refused,
so that read-only is enforced, not conventional.

### Access exists only where the image put it (todo)

I want a session created with no configuration image authenticating to gcp not
at all,
so that gcp access is never the default state.

## As a session user

Uses gcp from the session. Does not handle credentials.

### GCP works without being handed a credential (todo)

I want the sandbox service account present in the configuration image and
authenticating at session start,
so that no secret passes through the session start path.

### Every session authenticates identically (todo)

I want two sessions on the same configuration image presenting the same service
account,
so that behaviour never depends on which session runs the work.

<!--[<] 🤖🤖 -->
