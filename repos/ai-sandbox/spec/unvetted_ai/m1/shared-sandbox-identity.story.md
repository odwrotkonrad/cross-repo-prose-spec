# Feature: Shared sandbox identity

<!--[>] 🤖🤖 -->

## As a security owner

Reasons about what a sandbox can reach. Does not run sessions.

### One grant set covers every session (todo)

I want two sessions presenting the same identity to gcp and gitlab, neither
holding a credential the other lacks,
so that there is one permission set to audit.

### The credential inventory is closed (todo)

I want the declared identities enumerating gcp and gitlab and nothing else
issued to a session,
so that no credential exists outside the declaration.

<!--[<] 🤖🤖 -->
