# Feature: Remote Source Ref Pinning

<!-- [>] 🤖🤖 -->

A remote source pins a git ref with `?ref=<tag|branch>`, the query riding the
source and never the profile name:
`@<repo>[//<subdir>]/<spec-file>.yml::<profile>?ref=<ref>`. Profile sources,
`include.sources`, renderTemplates sources and `remoteFile` share it.

The `@<tag|sha>` suffix form (`@<repo>//<path>[@<ref>][::<profile>]`) is the
intended end state, not yet built: those stories stay `(todo)` until it lands,
with `?ref=` kept as an alias.

A pinned ref is immutable: fetched into its own checkout, never silently
replaced by a cached one. Unpinned tracks HEAD.

A pinned ref is immutable: fetched once into its own checkout, reused offline.
Unpinned tracks HEAD.

## As a spec author

Writes che specs consuming remote sources. Owns what a spec references, not how
it is fetched.

### Upstream HEAD no longer tracked once a source is pinned (todo)

I want `@<repo>//<path>/che.yml@<tag>::<profile>` checked out at `<tag>`, a
later push to the default branch changing nothing,
so that an upstream merge cannot alter what a host loads.

### One ref syntax across every remote source kind (todo)

I want profile sources, renderTemplates sources and `remoteFile` to accept the
same `@<ref>` suffix,
so that pinning is one thing to learn.

### Two pins of one repo coexisting in a run (implemented)

I want two renderTemplates or `remoteFile` sources of one repo at different
refs resolved from separate checkouts, neither overwriting the other,
so that a staged migration can pin one consumer ahead of another.

### A profile source pinning to a release (tested)

I want `@<giturl>[//<subdir>]/che.yml::<profile>?ref=<ref>` checked out at that
tag or branch, `${{ env.NAME }}` interpolation included,
so that a host loads the tool profiles of a known release, never a moving
branch.

### A spec source pinning the same way (tested)

I want `include.sources` entries accepting the same `?ref=<ref>` suffix,
so that one syntax pins every remote spec.

### Two profile sources of one repo pinned apart (tested)

I want two profile sources of one repo at different refs checked out
separately, neither resetting the other, the unpinned checkout untouched,
so that a staged migration can pin one included profile ahead of another.

### A malformed query failing at load (tested)

I want a query other than `ref=<ref>`, an empty ref, or a ref on a local dir
source rejected while the spec loads, naming the entry,
so that a typo never silently resolves to HEAD.

### Logs naming the ref (tested)

I want `init-remote-sources` output showing the ref beside the repo,
so that I can tell which release a run loaded.

### One leaf pinning apart from its neighbours, unambiguously (todo)

I want a pinned source parsed as ref `<tag>` and profile `<profile>`, an
SCP-style url with a user prefix (`@git@<host>:<group>/<repo>.git`) yielding no
ref, a source ending in a bare `@` reported as malformed,
so that the suffix never swallows a profile name or a url component.

### Existing pins working while the workspace migrates (todo)

I want `?ref=<ref>` to resolve the same ref as `@<ref>`,
so that specs migrate one at a time.

## As an operator

Runs che on an unreliable network. Reads failures, does not edit specs.

### A pinned run costing no network after its first fetch (todo)

I want an already-fetched pinned source reused from cache without a fetch,
so that a pinned host converges offline.

### An unresolvable pin failing loudly (tested)

I want a renderTemplates or `remoteFile` ref missing upstream to fail the run
naming source and ref, no stale checkout substituted,
so that a bad pin is never papered over with old content.

### An unresolvable profile pin failing loudly (tested)

I want a profile source at a ref missing upstream to abort the run naming
source and ref, no cached checkout substituted,
so that a bad profile pin is never papered over with old content.

### An unpinned source keeping its resilient update behavior (tested)

I want a failed fetch on an unpinned profile source with a cached checkout to
proceed silently on the cache,
so that tracking HEAD tolerates a flaky remote without noise.

### An unpinned template source surviving a flaky remote (todo)

I want a failed fetch on an unpinned renderTemplates or `remoteFile` source
with a cached checkout to warn and render from the cache,
so that every unpinned source kind tolerates a flaky remote alike.

<!-- [<] 🤖🤖 -->
