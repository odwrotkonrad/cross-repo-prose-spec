# Feature: renderTemplates Nested Groups

<!-- [>] 🤖🤖 -->

`renderTemplates` is a tree. A node is a leaf (source + dest) or a group
(shared `source` prefix, `options`, `ctx`, perms, plus nested
`renderTemplates`). Groups nest arbitrarily deep. The `templates:` key is gone:
a group's payload is its nested `renderTemplates`.

A group's `source` is a prefix joined onto every descendant leaf's `source`. For
a remote prefix the join recombines rather than concatenates: the pin stays last
in the resulting ref, so one repo+ref is typed once per repo instead of once per
file.

Cascade order, outermost first, child wins: perms per field, `ctx` per key,
`options` per field, `source` and `dest` prefixes by join. Dest-level `options`
win last, and an explicit `false` beats an inherited `true`.

`dest` accepts a bare path string. A scalar `dest` is a dest rewrite rule only
when it looks like one (`s<delim>…` or `<prefix>/**`), otherwise it is a path.

## Authoring

Scenario: one repo+ref pin per repo instead of one per template
  Status: todo
  Given a group whose `source` is a pinned remote repo and whose nested leaves carry repo-relative paths
  When che resolves the profile
  Then each leaf resolves against that repo at that ref
  And bumping the pin is a one-line edit

Scenario: shared render options stop being retyped on every template
  Status: todo
  Given a group carrying `options` and nested leaves carrying none
  When che renders them
  Then every leaf renders with the group's options

Scenario: an author reads a dest path as a path
  Status: todo
  Given a leaf with a scalar `dest` that is a plain path
  When the spec is loaded
  Then the leaf gets that single dest path
  And no dest rewrite rule is derived from it

Scenario: existing dest rewrites keep working unchanged
  Status: todo
  Given a leaf with a scalar `dest` of `s:^_home:$HOME:` or `$HOME/**`
  When the spec is loaded
  Then it is a dest rewrite rule, as before nested groups

## Nesting and cascade

Scenario: a deep doc tree is expressed without repeating its path prefix
  Status: todo
  Given a group nesting a group nesting leaves
  When che resolves the profile
  Then each leaf's source is the outer prefix joined with the inner prefix joined with the leaf path

Scenario: an inner group overrides what the outer group set
  Status: todo
  Given an outer group setting perms, `ctx` keys and `options` fields
  And an inner group and leaf re-setting some of them
  When che resolves the profile
  Then the innermost setting wins per field and per ctx key
  And unset fields keep the outer value

Scenario: a per-dest option still has the last word
  Status: todo
  Given a group setting an `options` field and a leaf dest setting the same field
  When che renders that dest
  Then the dest's value applies

Scenario: one leaf opts out of an option its whole group needs
  Status: todo
  Given a group setting an option `true` so most of its leaves inherit it
  And one nested leaf setting the same option `false`
  When che renders them
  Then that leaf renders with the option off
  And its siblings keep the group's value

Scenario: a shared dest directory is typed once, not per template
  Status: todo
  Given a group whose `dest` is a directory prefix and whose leaves carry file-name dests
  When che resolves them
  Then each dest is the group prefix joined with the leaf's dest

Scenario: a host dest under a repo-dest group still targets the host
  Status: todo
  Given a group carrying a repo-relative `dest` prefix
  And a nested leaf whose dest starts with `~/`, `/` or `$`
  When che resolves that leaf
  Then its dest is left unprefixed and still targets the host

Scenario: a group dest that is not a single prefix is caught at load
  Status: todo
  Given a group whose `dest` carries more than one path, or per-dest options
  When the spec is loaded
  Then che reports that a group dest is a prefix

Scenario: one leaf pins a different ref than its group
  Status: todo
  Given a group with a pinned remote prefix
  And a nested leaf carrying its own pin
  When che resolves that leaf
  Then the leaf's pin wins
  And its siblings keep the group's pin

Scenario: a local prefix composes like a path
  Status: todo
  Given a group whose `source` is a local directory prefix
  When che resolves its nested leaves
  Then each leaf source is the prefix joined with the leaf path, workingDirectory-relative

## Errors

Scenario: a malformed group prefix fails once, not once per template
  Status: todo
  Given a group whose remote prefix cannot form a valid `@<repo>//<path>` ref
  When the spec is loaded
  Then che reports one error naming that group
  And no per-leaf errors are emitted

Scenario: a bad pin surfaces as a single fetch failure
  Status: todo
  Given a group pinned to a ref that does not exist upstream
  When che resolves the profile
  Then one fetch error names the repo and the ref
  And it is not repeated per nested leaf

Scenario: a node cannot be both group and leaf
  Status: todo
  Given a node carrying nested `renderTemplates` and also a dest rewrite rule or glob
  When the spec is loaded
  Then che reports the node as invalid

Scenario: a group with nothing nested is caught at load
  Status: todo
  Given a node carrying a `source` prefix and no nested `renderTemplates`, dest or glob
  When the spec is loaded
  Then che reports that the group needs nested `renderTemplates`

## Schema and migration

Scenario: an editor validates arbitrarily nested groups
  Status: todo
  Given the generated `che.schema.json`
  When a spec nests groups three levels deep
  Then the schema validates it via a self-referencing node definition
  And it carries no `templates` key definition

Scenario: rendering output is unchanged by the syntax migration
  Status: todo
  Given a repo's `che.yml` migrated from `templates:` groups to nested groups
  When `make render-templates` runs
  Then every rendered file is byte-identical to the pre-migration output

<!-- [<] 🤖🤖 -->
