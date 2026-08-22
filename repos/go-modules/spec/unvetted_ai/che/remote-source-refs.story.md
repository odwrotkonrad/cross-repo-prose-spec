# Feature: Remote Source Ref Pinning

<!-- [>] 🤖🤖 -->

A remote source is marked by a literal `git::` prefix and pins a git ref with
`@<tag|branch>` in the repo position, never on the path or the profile name:

```
git::<repo>[@<ref>]//<path>                      renderTemplates / makeCopies / remoteFile
git::<repo>[@<ref>][//<subdir>]/<file>.yml::<p>  include.profiles
git::<repo>[@<ref>]                              include.sources, group prefixes
```

`<repo>` is a bare host path (`gitlab.com/org/repo`, https with ssh-agent
fallback), an explicit scheme (`https://`, `ssh://`, `file://`), or SCP
(`git@host:group/repo.git`). `<ref>` is the segment after the last `@` past the
authority, so neither an SCP user `@`, an `ssh://git@host` userinfo, nor a
scheme's own `//` is ever read as a ref or a path separator. A trailing `@`
with nothing after it is malformed, never userinfo. `?ref=` is rejected.

A group prefix and its leaves concatenate as plain strings: `git::repo@v1` +
`//prompts` + `/commit.md.tpl`.

A pinned ref is immutable: fetched once into its own checkout, reused offline,
never silently replaced by a cached one. Unpinned tracks HEAD.

## As a spec author

Writes che specs consuming remote sources. Owns what a spec references, not how
it is fetched.

### Upstream HEAD no longer tracked once a source is pinned (tested)

I want `git::<repo>@<tag>//<subdir>/che.yml::<profile>` checked out at `<tag>`,
a later push to the default branch changing nothing,
so that an upstream merge cannot alter what a host loads.

### One ref syntax across every remote source kind (tested)

I want profile sources, `include.sources`, renderTemplates sources and
`remoteFile` to accept the same `git::<repo>[@<ref>]//<path>` grammar,
so that pinning is one thing to learn.

### A group prefix concatenating with its leaves (tested)

I want a remote group prefix `git::<repo>@<ref>` and its leaf paths joined by
plain concatenation, every leaf resolving from the prefix's one checkout,
so that a pinned group needs no per-leaf repetition of the ref.

### One ref per group, pinned at the top entry (tested)

I want a leaf under a remote group prefix to take the group's ref with no way
to override it, pinning a path apart meaning its own top-level entry,
so that one group always resolves from exactly one checkout.

### Two pins of one repo coexisting in a run (implemented)

I want two renderTemplates or `remoteFile` sources of one repo at different
refs resolved from separate checkouts, neither overwriting the other,
so that a staged migration can pin one consumer ahead of another.

### A profile source pinning to a release (tested)

I want `git::<giturl>@<ref>[//<subdir>]/che.yml::<profile>` checked out at that
tag or branch, `${{ env.NAME }}` interpolation included,
so that a host loads the tool profiles of a known release, never a moving
branch.

### A spec source pinning the same way (tested)

I want `include.sources` entries accepting the same `git::<repo>@<ref>` form,
so that one syntax pins every remote spec.

### Two profile sources of one repo pinned apart (tested)

I want two profile sources of one repo at different refs checked out
separately, neither resetting the other, the unpinned checkout untouched,
so that a staged migration can pin one included profile ahead of another.

### A malformed ref failing at load (tested)

I want a `?ref=` query, a bare trailing `@`, a missing `git::` marker, or a ref
on a local dir source rejected while the spec loads, naming the entry and the
syntax that replaces it,
so that a typo never silently resolves to HEAD.

### Logs naming the ref (tested)

I want `init-remote-sources` output showing the ref beside the repo,
so that I can tell which release a run loaded.

### One leaf pinning apart from its neighbours, unambiguously (tested)

I want `git::git@<host>:<group>/<repo>.git@<tag>//che.yml::<profile>` parsed as
ref `<tag>` and profile `<profile>`, the same url without a `@<tag>` yielding no
ref, a repo ending in a bare `@` reported as malformed,
so that the ref anchor never swallows a profile name or an SCP user.

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
