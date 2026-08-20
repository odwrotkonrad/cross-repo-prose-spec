# Feature: renderTemplates Nested Groups

<!-- [>] 🤖🤖 -->

`renderTemplates` is a tree. A node is a leaf (source + dest) or a group (shared
`source` prefix, `options`, `ctx`, perms, plus nested `renderTemplates`). Groups
nest arbitrarily deep. The `templates:` key is gone: a group's payload is its
nested `renderTemplates`.

A group's `source` is a prefix joined onto every descendant leaf's `source`. A
remote prefix recombines rather than concatenates: the pin stays last in the
resulting ref, so repo+ref is typed once per repo instead of once per file.

Cascade order, outermost first, child wins: perms per field, `ctx` per key,
`options` per field, `source` and `dest` prefixes by join. Dest-level `options`
win last. An explicit `false` beats an inherited `true`.

`dest` accepts a bare path string. A scalar `dest` is a dest rewrite rule only
when it looks like one (`s<delim>…` or `<prefix>/**`), otherwise it is a path.

## As a spec author

Writes `renderTemplates` blocks. Cares what a spec says, not how the tree is
walked.

### One repo+ref pin per repo instead of one per template (tested)

I want a group whose `source` is a pinned remote repo to resolve each nested
leaf against that repo at that ref, bumping the pin being a one-line edit,
so that a repo's ref is stated once.

### Shared render options stated once (tested)

I want leaves carrying no `options` to render with their group's,
so that a common setting is not retyped per template.

### A deep doc tree without a repeated path prefix (tested)

I want a group nesting a group nesting leaves to give each leaf source the outer
prefix joined with the inner prefix joined with the leaf path,
so that a tree is expressed as a tree.

### A shared dest directory typed once (tested)

I want a group `dest` directory prefix joined with each leaf's file-name dest,
so that moving an output directory is one edit.

### A dest path read as a path (tested)

I want a scalar `dest` that is a plain path to be that single dest with no
rewrite rule derived, while `s:^_home:$HOME:` or `$HOME/**` stays a rewrite rule
as before,
so that a plain path never becomes an accidental rewrite.

### A host dest under a repo-dest group still targeting the host (tested)

I want a nested leaf whose dest starts with `~/`, `/` or `$` left unprefixed
under a repo-relative group dest,
so that one host file among repo outputs needs no separate group.

## As a spec author overriding within a tree

Sets values at several depths deliberately. Expects the innermost to win.

### An inner group overriding the outer (tested)

I want the innermost setting to win per field and per ctx key, unset fields
keeping the outer value,
so that a group states the common case and a child states its exception.

### A per-dest option with the last word (tested)

I want a dest's `options` value to apply over its group's,
so that the most specific statement is the effective one.

### One leaf opting out of an option its group needs (tested)

I want a nested leaf setting an option `false` under a group setting it `true`
to render with it off, its siblings keeping the group's value,
so that one exception does not force the group apart.

### One leaf pinning a different ref than its group (tested)

I want a nested leaf's own pin to win over its group's, siblings keeping the
group's,
so that a single file can lag or lead a repo bump.

### A local prefix composing like a path (tested)

I want a local directory `source` prefix joined with each leaf path,
workingDirectory-relative,
so that local and remote prefixes read the same way.

## As a spec author reading an error

Wants one failure naming one cause. Does not want the same fault repeated per
leaf.

### A malformed group prefix failing once (tested)

I want a group whose remote prefix cannot form a valid `@<repo>//<path>` ref to
report one error naming that group, no per-leaf errors,
so that the message points at the thing to fix.

### A bad pin surfacing as a single fetch failure (tested)

I want a fetch error to name the repo and the ref,
so that a bad pin points at the thing to fix.

### A bad pin reported once across every leaf it feeds (todo)

I want a failed fetch of one repo+ref reported once, the remaining leaves on
that pin skipped without repeating the error,
so that a bad pin is one line of output.

### An invalid node caught at load (implemented)

I want a node carrying nested `renderTemplates` plus a dest rewrite rule or glob
reported as invalid, and a group `dest` carrying more than one path or per-dest
options reported as needing a prefix,
so that a malformed tree fails before anything renders.

### A prefix with nothing nested rejected (todo)

I want a `source` directory prefix carrying no nested `renderTemplates`
reported as needing them,
so that a forgotten nesting fails at load, not as a missing template file.

## As a repo owner migrating

Converts an existing `che.yml` off `templates:`. Wants no output change.

### An editor validating arbitrarily nested groups (tested)

I want the generated `che.schema.json` to validate three-level nesting via a
self-referencing node definition and to carry no `templates` key definition,
so that the editor enforces the shape the loader accepts.

### Rendering output unchanged by the syntax migration (implemented)

I want `make render-templates` after migrating to produce byte-identical files,
so that a syntax change is provably not a content change.

<!-- [<] 🤖🤖 -->
