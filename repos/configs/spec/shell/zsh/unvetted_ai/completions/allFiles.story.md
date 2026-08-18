# Feature: deep file-path completion (dirs for cd, files and dirs for file commands)

<!-- [>] 🤖🤖 -->

## As a developer

Moves between deep directory trees all day, types fragments, never full paths.

### Nearby directories reachable without typing the path (implemented)

I want an empty or relative query listing the levels that have matches in order
`*`, `*/*`, `*/*/*`, `../*`, `../*/*`, `../../*`, `Stack *`, `~*`, each relative
to `$PWD`, with `*/*` capped at 12 hints and `*/*/*`, `../*`, `../*/*`,
`../../*` capped at 6 each,
so that a sibling or a grandchild is one TAB away, not a typed path.

### A typed prefix anchors the search where you meant it (implemented)

I want a slash-anchored prefix (`/dir/`, `~/`, `~name/`) listing `<base>/*`,
`<base>/*/*`, `<base>/*/*/*`, omitting the relative-up and `~*` levels, the
query after the last `/` fuzzy-matching, an absolute prefix inserting the
absolute path and a `~` prefix listing and inserting in `~` form,
so that an anchored request never drags in results from elsewhere.

### A single fragment finds a segment at any depth (implemented)

I want a query with no path separator fuzzy-matching a single filepath segment,
the match's own segment for its group, a shallower match never carried into a
deeper group,
so that `rt` finds `root` and `data` finds it at every depth it exists.

### A sloppy partial path still resolves (implemented)

I want a query with separators divided per segment, each fuzzy-matching a path
segment in typed order with skipped segments allowed between them and the last
matching the match's own segment,
so that `r/src` reaches `root/datasource` without the intermediate names.

### The directory stack is searchable, not just cyclable (implemented)

I want a stack entry listed only when the query fuzzy-matches it per path
segment, `/` on the stack listing and inserting exactly one `/`,
so that a pushed directory is recalled by fragment.

### Named dirs offered without hijacking the path form (implemented)

I want a trailing `~*` group listing each named dir as `~name` after all other
groups on an empty or relative query, the query fuzzy-matching the names, a
named dir whose target is `$PWD` omitted, accepting inserting `~name/`, a bare
`~` listing the home levels plus `~*`, and a `~query` listing `~*` only while
`~name/...` still completes through the anchored levels,
so that named dirs stay available without displacing ordinary path completion.

## As a repo owner

Tunes the completion zstyles, wants every group to obey the same listing rules.

### Every level shows both visibilities under one budget (implemented)

I want each level listing a non-hidden and a hidden group sharing the level's
max-hints, non-hidden first and hidden filling the remainder directly below,
the heading belonging to the level and always listed,
so that a hidden-only level is still labelled and a level never doubles its
budget.

### Hint counts are bounded and predictable (implemented)

I want each group truncated to its max-hints, a level with none configured
truncated to 6, every non-hidden match listed before every hidden one with none
interleaved, and a level's two groups sharing the smaller of their column
counts,
so that the listing height is bounded and reads as one block per level.

### Ancestor levels do not repeat their descendants (implemented)

I want `../*` omitting `$PWD` itself, `../*/*` omitting `$PWD`'s own children,
and `../../*` omitting the parent dir,
so that each path appears once, under the shallowest level that covers it.

### Stack expansion is opt-in (implemented)

I want only the base `Stack *` group listed by default, `stack+1` and `stack+2`
in the groups zstyle expanding matched entries into `Stack */*` and
`Stack */*/*` groups capped at 6 hints, non-hidden before hidden, a hidden-only
stack level keeping its heading,
so that the stack costs one group until deeper listing is asked for.

<!-- [<] 🤖🤖 -->
