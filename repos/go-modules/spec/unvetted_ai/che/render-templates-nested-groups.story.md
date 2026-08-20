# Feature: renderTemplates Nested Groups

<!-- [>] 🤖🤖 -->

`renderTemplates` is a tree. A node is a leaf (source + dest) or a group (shared
`source` prefix, `options`, `ctx`, perms, nested `renderTemplates`). Groups nest
to any depth. No `templates:` key: a group's payload is its nested
`renderTemplates`.

A group's `source` prefixes every descendant leaf's `source`. A remote prefix
recombines instead of concatenating: the pin stays last in the ref, so repo+ref
is typed once per repo.

Cascade, outermost first, child wins: perms per field, `ctx` per key, `options`
per field, `source` and `dest` prefixes by join. Dest-level `options` win last.
Explicit `false` beats inherited `true`.

`dest` takes a bare path. A scalar `dest` is a rewrite rule only when shaped
like one (`s<delim>…` or `<prefix>/**`).

## As a spec author

Writes `renderTemplates` blocks. Cares what a spec says, not how the tree is
walked.

### One repo+ref pin per repo instead of one per template (tested)

I want a group with a pinned remote `source` to resolve each nested leaf
against that repo at that ref,
so that a ref is stated once and bumped in one line.

### Shared render options stated once (tested)

I want leaves without `options` to render with their group's,
so that a common setting is not retyped per template.

### A deep doc tree without a repeated path prefix (tested)

I want each leaf source to be outer prefix joined with inner prefix joined with
leaf path,
so that a tree is written as a tree.

### A shared dest directory typed once (tested)

I want a group `dest` directory joined with each leaf's file-name dest,
so that moving an output directory is one edit.

### A dest path read as a path (tested)

I want a plain-path scalar `dest` to be that one dest, no rewrite rule derived,
while `s:^_home:$HOME:` or `$HOME/**` stays a rewrite rule,
so that a plain path never becomes an accidental rewrite.

### A host dest under a repo-dest group still targeting the host (tested)

I want a nested leaf dest starting with `~/`, `/` or `$` left unprefixed under
a repo-relative group dest,
so that one host file among repo outputs needs no separate group.

## As a spec author overriding within a tree

Sets values at several depths on purpose. Expects the innermost to win.

### An inner group overriding the outer (tested)

I want the innermost setting to win per field and per ctx key, unset fields
keeping the outer value,
so that a group states the common case and a child its exception.

### A per-dest option with the last word (tested)

I want a dest's `options` to apply over its group's,
so that the most specific statement wins.

### One leaf opting out of an option its group needs (tested)

I want a nested leaf setting an option `false` under a group setting it `true`
to render with it off, siblings keeping the group's value,
so that one exception does not split the group.

### One leaf pinning a different ref than its group (tested)

I want a nested leaf's own pin to win over its group's, siblings keeping the
group's,
so that one file can lag or lead a repo bump.

### A local prefix composing like a path (tested)

I want a local directory `source` prefix joined with each leaf path,
workingDirectory-relative,
so that local and remote prefixes read the same.

## As a spec author reading an error

Wants one failure naming one cause, not the same fault repeated per leaf.

### A malformed group prefix failing once (tested)

I want a group whose remote prefix cannot form a valid `@<repo>//<path>` ref to
report one error naming the group, no per-leaf errors,
so that the message points at the thing to fix.

### A bad pin surfacing as a single fetch failure (tested)

I want a fetch error to name the repo and the ref,
so that a bad pin points at the thing to fix.

### A bad pin reported once across every leaf it feeds (todo)

I want a failed fetch of one repo+ref reported once, remaining leaves on that
pin skipped silently,
so that a bad pin is one line of output.

### An invalid node caught at load (implemented)

I want a node with nested `renderTemplates` plus a dest rewrite rule or glob
rejected as invalid, and a group `dest` with more than one path or per-dest
options rejected as needing a prefix,
so that a malformed tree fails before anything renders.

### A prefix with nothing nested rejected (todo)

I want a `source` directory prefix with no nested `renderTemplates` rejected,
so that a forgotten nesting fails at load, not as a missing template file.

## As a repo owner migrating

Converts an existing `che.yml` off `templates:`. Wants no output change.

### An editor validating arbitrarily nested groups (tested)

I want the generated `che.schema.json` to validate three-level nesting through a
self-referencing node definition and to define no `templates` key,
so that the editor enforces the shape the loader accepts.

### Rendering output unchanged by the syntax migration (implemented)

I want `make render-templates` after migrating to produce byte-identical files,
so that a syntax change is provably not a content change.

<!-- [<] 🤖🤖 -->
