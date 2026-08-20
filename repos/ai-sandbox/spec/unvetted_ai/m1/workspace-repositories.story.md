# Feature: Workspace repositories

<!--[>] 🤖🤖 -->

## As a session user

Works on the workspace repos. Does not clone them by hand.

### The workspace arrives whole (implemented)

I want the cloning che profile cloning every repository in the named gitlab
groups, laid out mirroring the group structure,
so that paths are the same in every session and on the host.

### A credential-less session fails clean (implemented)

I want no cloning at all when the gitlab token is absent,
so that no one works in a half-populated workspace.

## As a sandbox operator

Wires cloning and egress. Does not choose the groups.

### Repos are not frozen into the image (todo)

I want no repository present before the cloning profile runs,
so that the image never ships stale code.

### Cloning works under default deny (implemented)

I want a whitelist rule naming gitlab admitting the clone,
so that the policy and the workflow are consistent.

<!--[<] 🤖🤖 -->
