# Feature: Workspace Index On Configs Sync

<!-- [>] 🤖🤖 -->

Workspace indexing lives in `control`, consumed here through a remote profile
include. This repo owns only the wiring: which targets the routine sync runs,
in what order.

Order matters. The index inlines each repo's rendered purpose doc, which the
host load produces and gitignore keeps out of the tree. Indexing before that
load reads nothing.

## As a sync user

Runs one sync target on a host, knows nothing of the ops beneath it.

### One command leaves configs loaded and the map current (implemented)

I want the routine sync refreshing the workspace indexes after loading configs,
so that the map is current without knowing which repo generates it.

### A refresh needs no gitlab credential (implemented)

I want the index step running with no token in the environment,
so that the routine sync never depends on a credential it does not otherwise need.

### Each repo's purpose reaches the map (implemented)

I want indexing ordered after the renders producing this repo's purpose doc,
so that configs never appears in the map without its purpose.

### Sibling repos' purposes render before the routine index (todo)

I want the routine sync rendering every cloned repo's purpose doc before
indexing,
so that no sibling appears in the map without its purpose.

### The full sync keeps its behavior (implemented)

I want the full sync still clone-then-index through the combined profile, no
second refresh,
so that the heavier path is unchanged by the routine one gaining a step.

## As a configs maintainer

Owns the wiring and the remote include, duplicates nothing `control` serves.

### Index logic has one home (implemented)

I want the sync invoking `control`'s index profile through the remote include,
never reimplementing the walk here,
so that the map's shape cannot drift between two implementations.

### The include names a version (todo)

I want the `control` include pinned at a tag like the prose include beside it,
so that a sync resolves a known revision, not a moving branch.

### The inventory describes files this repo holds (implemented)

I want the tools inventory free of the profile tree that moved to `control`,
so that a reader is never sent to a path this repo no longer carries.

<!-- [<] 🤖🤖 -->
