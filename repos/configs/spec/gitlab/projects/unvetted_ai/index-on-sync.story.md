# Feature: Workspace Index On Configs Sync

<!-- [>] 🤖🤖 -->

The workspace index behavior lives in `control`, consumed here through a remote
profile include. This repo owns only the wiring: which targets the routine sync
runs, and in what order.

Ordering is load-bearing. The index inlines each repo's rendered purpose doc,
which the host load produces and gitignore keeps out of the tree, so indexing
before that load reads nothing.

## As a sync user

Runs one sync target on a host. Knows nothing of the ops beneath it.

### One command leaves configs loaded and the map current (todo)

I want the routine sync to refresh the workspace indexes after loading configs,
so that the map is current without knowing which repo generates it.

### A refresh needs no gitlab credential (todo)

I want the index step to run with no token in the environment,
so that the routine sync never depends on a credential it does not otherwise need.

### Each repo's purpose reaches the map (todo)

I want indexing ordered after the renders producing each repo's purpose doc,
so that no repo appears in the map without its purpose.

### The full sync keeps its existing behavior (todo)

I want the full sync still clone-then-index through the combined profile, gaining
no second refresh,
so that the heavier path is unchanged by the routine one gaining a step.

## As a configs maintainer

Owns the wiring and the remote include. Duplicates no logic served from `control`.

### Index logic has one home (todo)

I want the sync invoking `control`'s index profile through the remote include,
never reimplementing the walk here,
so that the map's shape cannot drift between two implementations.

### The include names a version (todo)

I want the `control` include pinned at a tag like the prose include beside it,
so that a sync resolves a known revision instead of a moving branch.

### Inventory describes files this repo holds (todo)

I want the tools inventory free of the profile tree that moved to `control`,
so that a reader is never sent to a path this repo no longer carries.

<!-- [<] 🤖🤖 -->
