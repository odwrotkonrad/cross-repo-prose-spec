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

### One repo+ref pin per repo instead of one per template (todo)

I want a group whose `source` is a pinned remote repo to resolve each nested
leaf against that repo at that ref, bumping the pin being a one-line edit,
so that a repo's ref is stated once.

### Shared render options stated once (todo)

I want leaves carrying no `options` to render with their group's,
so that a common setting is not retyped per template.

### A deep doc tree without a repeated path prefix (todo)

I want a group nesting a group nesting leaves to give each leaf source the outer
prefix joined with the inner prefix joined with the leaf path,
so that a tree is expressed as a tree.

### A shared dest directory typed once (todo)

I want a group `dest` directory prefix joined with each leaf's file-name dest,
so that moving an output directory is one edit.

### A dest path read as a path (todo)

I want a scalar `dest` that is a plain path to be that single dest with no
rewrite rule derived, while `s:^_home:$HOME:` or `$HOME/**` stays a rewrite rule
as before,
so that a plain path never becomes an accidental rewrite.

### A host dest under a repo-dest group still targeting the host (todo)

I want a nested leaf whose dest starts with `~/`, `/` or `$` left unprefixed
under a repo-relative group dest,
so that one host file among repo outputs needs no separate group.

## As a spec author overriding within a tree

Sets values at several depths deliberately. Expects the innermost to win.

### An inner group overriding the outer (todo)

I want the innermost setting to win per field and per ctx key, unset fields
keeping the outer value,
so that a group states the common case and a child states its exception.

### A per-dest option with the last word (todo)

I want a dest's `options` value to apply over its group's,
so that the most specific statement is the effective one.

### One leaf opting out of an option its group needs (todo)

I want a nested leaf setting an option `false` under a group setting it `true`
to render with it off, its siblings keeping the group's value,
so that one exception does not force the group apart.

### One leaf pinning a different ref than its group (todo)

I want a nested leaf's own pin to win over its group's, siblings keeping the
group's,
so that a single file can lag or lead a repo bump.

### A local prefix composing like a path (todo)

I want a local directory `source` prefix joined with each leaf path,
workingDirectory-relative,
so that local and remote prefixes read the same way.

## As a spec author reading an error

Wants one failure naming one cause. Does not want the same fault repeated per
leaf.

### A malformed group prefix failing once (todo)

I want a group whose remote prefix cannot form a valid `@<repo>//<path>` ref to
report one error naming that group, no per-leaf errors,
so that the message points at the thing to fix.

### A bad pin surfacing as a single fetch failure (todo)

I want one fetch error naming the repo and the ref, not repeated per nested
leaf,
so that a bad pin is one line of output.

### An invalid node caught at load (todo)

I want a node carrying nested `renderTemplates` plus a dest rewrite rule or glob
reported as invalid, a group `dest` carrying more than one path or per-dest
options reported as needing a prefix, and a `source` prefix with nothing nested
reported as needing nested `renderTemplates`,
so that a malformed tree fails before anything renders.

## As a repo owner migrating

Converts an existing `che.yml` off `templates:`. Wants no output change.

### An editor validating arbitrarily nested groups (todo)

I want the generated `che.schema.json` to validate three-level nesting via a
self-referencing node definition and to carry no `templates` key definition,
so that the editor enforces the shape the loader accepts.

### Rendering output unchanged by the syntax migration (todo)

I want `make render-templates` after migrating to produce byte-identical files,
so that a syntax change is provably not a content change.

<!-- [<] 🤖🤖 -->
