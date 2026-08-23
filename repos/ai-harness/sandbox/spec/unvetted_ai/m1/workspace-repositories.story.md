# Feature: Workspace repositories

<!--[>] 🤖🤖 -->

## As a session user

Works on the workspace repos. Does not clone them by hand.

### The workspace arrives whole (implemented)

I want the cloning che profile cloning every repo in the named gitlab groups,
laid out to mirror the group tree,
so that paths match across sessions and the host.

### A credential-less session fails clean (implemented)

I want no cloning at all when the gitlab token is absent,
so that no one works in a half-populated workspace.

## As a sandbox operator

Wires cloning and egress. Does not choose the groups.

### Repos are not frozen into the image (todo)

I want no repo present before the cloning profile runs,
so that the image never ships stale code.

### Cloning works under default deny (implemented)

I want an allowlist rule naming gitlab admitting the clone,
so that policy and workflow agree.

<!--[<] 🤖🤖 -->
