# Feature: Shared sandbox identity

<!--[>] 🤖🤖 -->

## As a security owner

Reasons about what a sandbox can reach. Runs no sessions.

### One grant set covers every session (implemented)

I want two sessions presenting the same identity to gcp and gitlab, neither
holding a credential the other lacks,
so that there is one permission set to audit.

### The credential inventory is closed (implemented)

I want the declared identities enumerating gcp and gitlab,
so that every grant has a declaration to read.

### No undeclared credential reaches a session (todo)

I want nothing beyond the declared identities issued to a session,
so that no credential exists outside the declaration.

<!--[<] 🤖🤖 -->
