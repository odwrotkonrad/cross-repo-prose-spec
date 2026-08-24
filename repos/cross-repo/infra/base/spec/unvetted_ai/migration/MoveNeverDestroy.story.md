# Feature: Resources move between states, never get destroyed

<!-- [>] 🤖🤖 -->

Splitting one terraform root into several moves live resources between states.
The naive path deletes from one root and creates in the other, which destroys a
GitLab project, a billing-attached GCP project, or the GPG key every installed
apt client trusts.

The safe path is the reverse pair: `import` into the new root first, so the
resource sits in two states at once, then `removed` with `destroy = false` in
the old root, which drops it from state and leaves it alive. Between those two
steps nothing is at risk, because both states describe a resource that exists.

Every plan in this sequence is checked for delete actions before it is applied.
Zero is the only acceptable count.

## As the infra operator

Carries resources out of iac. Applies each step locally.

### Import before forgetting, never the reverse (todo)

I want each resource imported into its new root and applied there before the
old root forgets it,
so that no window exists where no state describes a live resource.

### Prove no plan destroys anything (todo)

I want every plan in the migration checked for `delete` actions with a
mechanical query over the plan JSON, expecting an empty list,
so that a destroy is caught before apply rather than read about afterwards.

### Reach an import-only plan before applying (todo)

I want the new root's first plan to show only imports, never a `~` or `+` on a
resource that already exists,
so that a diff means my config drifted from live and I fix the config, never
the live resource.

### Move project shells before their contents (todo)

I want billing-attached projects and the `prevent_destroy` GCP project moved
ahead of anything living inside them,
so that a child imports against a project the new root already owns.

### Carry `prevent_destroy` across the move (todo)

I want the release-signing GPG key's `prevent_destroy` present in the new root
before the old root forgets it,
so that the key breaking every installed apt client cannot be replaced by a
plan side effect at any point in the move.

### Delete dead config in a separate commit (todo)

I want `removed` blocks and orphaned config deleted after the forget applies,
not in the same commit,
so that each apply does one thing and a bad step reverts without unpicking two.

### Skip an import that already happened (todo)

I want pending `import` blocks checked against live state before a move,
so that a resource already adopted is not imported twice into the new root.

<!-- [<] 🤖🤖 -->
