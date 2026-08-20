# Feature: Workspace Index Refresh On Sync

<!-- [>] 🤖🤖 -->

The subgroup indexes are the map agents read: `assets/data/repo-index.md` plus
rendered `AGENTS.md`/`CLAUDE.md` in every workspace parent dir. A map is worth
only its freshness. These went stale, still naming a repo folded away into prose
and missing three repos since added, because nothing on the ordinary sync path
regenerated them.

Three gates each stopped it independently: the routine sync skipped the
`run-scripts` op that carries indexing, the profile gated on `GITLAB_TOKEN` which
no host shell exports, and the index script gated on that variable again.

Indexing reads dirs already on disk. It needs no token and no network. Cloning
needs auth, and auth is not one environment variable: the clone discovers
projects through `glab`, whose credential normally lives in its own config, and
falls back to SSH. Splitting the two concerns lets each carry the gate it
actually has.

## As a workspace user

Runs the routine sync on a host. Regenerates no index by hand.

### The routine sync leaves a current map behind (implemented)

I want the ordinary sync to regenerate every subgroup index, not only the full
variant,
so that the map an agent reads describes the workspace as it is now.

### An index refresh asks for no credential (implemented)

I want indexing to run with no gitlab token in the environment and no network
call, reading only what is on disk,
so that the map stays current on a host that never exports a token.

### Repos that came and went are reflected (implemented)

I want each refresh to list every repo present and drop every repo gone,
so that no agent plans against a repo that no longer exists.

### Re-syncing changes nothing when nothing changed (implemented)

I want a second sync over an unchanged workspace to produce byte-identical
indexes,
so that the refresh is safe to run on every sync.

## As a workspace maintainer

Owns the profile's scripts and their gates. Writes each gate once, where the
dependency is.

### Cloning gates on real authentication, not one mechanism for it (implemented)

I want the clone gated on a command predicate making an authenticated api call,
satisfied by a token in the environment or by glab's own credential,
so that every context that can actually clone is admitted: a host using glab's
config, and an image build or CI job carrying only the token.

### A gate proves authentication rather than configuration (implemented)

I want the probe to be an api call, never a status subcommand that reports
success whenever a token is merely present,
so that a rejected or expired credential fails the gate instead of passing it and
failing later inside the clone.

### Indexing carries no gate it does not need (implemented)

I want the index path free of the token and group gates, keeping only its
guard against a missing `che`,
so that an unrelated credential never decides whether the map refreshes.

### The clone and index concerns are separately runnable (implemented)

I want indexing exposed as its own profile alongside the combined clone-then-index
path, and a named target invoking it,
so that a refresh is one command that touches no remote.

### A workspace with nothing to index is not a failure (implemented)

I want the index to succeed and do nothing when the workspace holds no repos yet
or does not exist, rather than aborting the run that invoked it,
so that an image build indexing before its first clone still completes.

### A skipped step says which gate stopped it (implemented)

I want each skip naming its cause, whether the gate lives in the profile or the
script,
so that silence is never mistaken for success.

### The generated map credits the repo that generates it (implemented)

I want the subgroup index template naming `control` as its origin, one template
tracked in one place,
so that no generated file sends a reader to the repo that stopped owning this.

<!-- [<] 🤖🤖 -->
