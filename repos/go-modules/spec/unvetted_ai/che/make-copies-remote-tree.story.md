# Feature: makeCopies Remote Tree

<!-- [>] 🤖🤖 -->

`makeCopies` takes the same node tree as `renderTemplates`: a leaf
(`source` + `dest`) or a group (shared `source` and `dest` prefixes, perms,
nested `<<<`). Groups nest to any depth. No `files:` key: a group's payload is
its nested `<<<`, a top-level leaf needs no group.

A source is a local `*.ontoHost.cp` file, profileWorkingDirectory-relative, or
remote, `@<repo>//<path>[?ref=<ref>]`. A remote group prefix recombines with
each leaf path so the pin stays last and is typed once per repo. Bytes copy
verbatim: a gomplate-bearing upstream file lands intact, its actions resolving
wherever it is consumed later.

Cascade, outermost first, child wins: perms per field, `source` and `dest`
prefixes by join. Dry-run, backup and stale sweep behave as for local copies.

## As a spec author

Writes `makeCopies` blocks. Cares what a spec says, not how the tree is walked.

### A remote file placed on the host byte-for-byte (tested)

I want a leaf with a remote `source` and an explicit host `dest` to land the
fetched bytes unchanged, `{{ }}` included,
so that an upstream prompt template is consumed where it runs, not re-rendered
on the way.

### One repo+ref pin per repo instead of one per file (tested)

I want a group with a pinned remote `source` to resolve each nested leaf
against that repo at that ref,
so that a ref is stated once and bumped in one line.

### Perms stated once for a group (tested)

I want leaves without perms to copy with their group's, an inner group
overriding per field,
so that a common mode is not retyped per file.

### A host dest under a group dest still anchoring itself (tested)

I want a nested leaf dest starting with `~/`, `/` or `$` left unprefixed under
a group `dest`,
so that one file elsewhere on the host needs no separate group.

### A dry run leaving the network alone (tested)

I want `--dry-run` to predict the write without fetching,
so that a dry run is offline and fast.

## As a spec author reading an error

### A remote glob or dest rewrite rejected at load (tested)

I want a remote glob source, a remote source with a dest rewrite rule, and a
remote leaf without an explicit dest each rejected at load, the error naming
`makeCopies`,
so that a malformed tree fails before anything is fetched.

### A group without a prefix rejected at load (tested)

I want a node with nested `<<<` but neither a `source` nor a `dest` prefix
rejected, in `makeCopies` and `renderTemplates` alike, the editor schema
agreeing,
so that `<<<` only ever assembles paths and perms-only sharing stays on leaves.

## As a repo owner migrating

Converts an existing `che.yml` off `files:`. Wants no output change.

### `.ontoHost.cp` glob discovery unchanged (tested)

I want glob leaves to keep selecting tracked `*.ontoHost.cp` files with derived
dests, `.ontoHost.cp` stripped,
so that the tree form changes nothing for existing local copies.

### An editor validating the tree (tested)

I want the generated `che.schema.json` to validate nested groups through a
self-referencing copy node and to define no `files` key,
so that the editor enforces the shape the loader accepts.

<!-- [<] 🤖🤖 -->
