# Feature: One terraform run at a time

<!-- [>] 🤖🤖 -->

Every branch pipeline plans, the default branch applies. Two pipelines at once
race on the same state: a plan reads state an apply is rewriting, two applies
contend for the GCS lock and one fails. GitLab's `resource_group` is the lock:
jobs sharing a group name run one at a time across every pipeline of the
project, the rest wait.

## As an infra operator

Merges to main, opens branches that plan. Never runs terraform by hand against
CI state.

### Plan and apply never overlap (implemented)

I want `plan` and `apply` in one `resource_group`,
so that concurrency is one terraform process per project, whatever pipelines
are running.

### A queued apply reports a stale plan instead of applying it (implemented)

I want an apply that waited behind another apply to run its saved plan
unchanged,
so that terraform refuses it on a state serial mismatch rather than applying a
plan made against state that has since moved.

<!-- [<] 🤖🤖 -->
