# Feature: Local clones follow moved projects

<!-- [>] 🤖🤖 -->

## As a workspace user

Keeps every group repo cloned under `~/projects/gitlab`, runs the workspace
profile to sync, never moves dirs by hand.

### A moved project moves its clone (implemented)

I want an existing clone whose project now lives at another path relocated
there, its origin repointed,
so that one project never has two checkouts.

### A dirty clone is never moved silently (implemented)

I want a clone with local changes left in place and named in the report,
so that nothing uncommitted is disturbed.

### An emptied subgroup dir is removed (implemented)

I want a dir holding no repo, only generated index files, deleted after the
sync,
so that the tree mirrors the group with no stale shells.

### Parent Makefile and workspace file follow the tree (implemented)

I want the parent Makefile repo list and the VS Code workspace folders
generated from the cloned tree,
so that a moved or new repo appears without a hand edit.

### Repos at any depth are seen (implemented)

I want aggregation and the index to find a repo three groups deep,
so that nesting never hides a repo.

### An index never lands inside a repo (implemented)

I want a subgroup whose child repo is named `assets` to get its index inlined
into `AGENTS.md` and `CLAUDE.md` instead of written under `assets/data/`,
so that a generated file never shows up as an untracked change in a checkout.

<!-- [<] 🤖🤖 -->
