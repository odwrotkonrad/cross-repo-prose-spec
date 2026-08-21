# Feature: Remote Source Ref Pinning

<!-- [>] 🤖🤖 -->

A remote source pins a git ref with `@<tag|sha>` after repo+path, before
`::<profile>`: `@<repo>//<path>[@<ref>][::<profile>]`. Profile sources,
renderTemplates sources and `remoteFile` share it. `?ref=<ref>` is a deprecated
alias: parsed, never emitted.

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

### Two profile sources of one repo pinned apart (todo)

I want two profile sources of one repo at different refs checked out
separately, neither resetting the other,
so that a staged migration can pin one included profile ahead of another.

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

### An unresolvable profile pin failing loudly (todo)

I want a profile source at a ref missing upstream to abort the run naming
source and ref, no cached checkout substituted,
so that a bad profile pin is never papered over with old content.

### An unpinned source keeping its resilient update behavior (tested)

I want a failed fetch on an unpinned profile source with a cached checkout to
warn and proceed on the cache,
so that tracking HEAD tolerates a flaky remote.

### An unpinned template source surviving a flaky remote (todo)

I want a failed fetch on an unpinned renderTemplates or `remoteFile` source
with a cached checkout to warn and render from the cache,
so that every unpinned source kind tolerates a flaky remote alike.

<!-- [<] 🤖🤖 -->
