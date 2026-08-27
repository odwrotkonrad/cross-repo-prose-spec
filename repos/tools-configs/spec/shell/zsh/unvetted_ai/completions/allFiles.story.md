# Feature: deep file-path completion (dirs for cd, files and dirs for file commands)

<!-- [>] 🤖🤖 -->

## As a developer

Moves through deep directory trees all day, types fragments, never full paths.

### Nearby directories reachable without typing the path (implemented)

I want an empty or relative query listing the levels with matches, in order
`*`, `*/*`, `*/*/*`, `../*`, `../*/*`, `../../*`, `Stack *`, `~*`, each
relative to `$PWD`, `*/*` capped at 12 hints, `*/*/*`, `../*`, `../*/*`,
`../../*` at 6 each,
so that a sibling or grandchild is one TAB away.

### A typed prefix anchors the search where you meant it (implemented)

I want a slash-anchored prefix (`/dir/`, `~/`, `~name/`) listing `<base>/*`,
`<base>/*/*`, `<base>/*/*/*` and no relative-up or `~*` levels, the text after
the last `/` fuzzy-matching, an absolute prefix listed and inserted shortened
to `~` or `~name` where `$HOME` or a named dir covers it, a `~` prefix listed
and inserted in `~` form,
so that an anchored request never drags in results from elsewhere.

### A single fragment finds a segment at any depth (implemented)

I want a query with no path separator fuzzy-matching one path segment, the
match's own segment for its group, a shallower match never carried into a
deeper group,
so that `rt` finds `root` and `data` finds it at every depth it exists.

### A sloppy partial path still resolves (implemented)

I want a query with separators split per segment, each fuzzy-matching a path
segment in typed order, segments skippable between them, the last matching
the match's own segment,
so that `r/src` reaches `root/datasource` without the names in between.

### The directory stack is searchable, not just cyclable (implemented)

I want a stack entry listed only when the query fuzzy-matches it per path
segment, `/` on the stack listed and inserted as exactly one `/`,
so that a pushed directory is recalled by fragment.

### Named dirs offered without hijacking the path form (implemented)

I want a trailing `~*` group listing each named dir as `~name` after all other
groups on an empty or relative query, the query fuzzy-matching the names, a
named dir targeting `$PWD` omitted, accepting inserting `~name/`, a bare `~`
listing the home levels plus `~*`, a `~query` listing `~*` only while
`~name/...` still completes through the anchored levels,
so that named dirs stay available without displacing plain path completion.

## As a repo owner

Tunes the completion zstyles, wants every group under the same listing rules.

### Every level shows both visibilities under one budget (implemented)

I want each level listing a non-hidden and a hidden group sharing the level's
max-hints, non-hidden first, hidden filling the remainder directly below, the
heading owned by the level and always listed,
so that a hidden-only level is still labelled and no level doubles its budget.

### Hint counts are bounded and predictable (implemented)

I want each group truncated to its max-hints, 6 when a level has none
configured, every non-hidden match before every hidden one, never interleaved,
a level's two groups sharing the smaller of their column counts,
so that listing height is bounded and reads as one block per level.

### Ancestor levels do not repeat their descendants (implemented)

I want `../*` omitting `$PWD`, `../*/*` omitting `$PWD`'s children, `../../*`
omitting the parent dir,
so that each path appears once, under the shallowest level covering it.

### Stack expansion is opt-in (implemented)

I want only the base `Stack *` group listed by default, `stack+1` and
`stack+2` in the groups zstyle expanding matched entries into `Stack */*` and
`Stack */*/*` groups capped at 6 hints, non-hidden before hidden, a
hidden-only stack level keeping its heading,
so that the stack costs one group until deeper listing is asked for.

<!-- [<] 🤖🤖 -->
