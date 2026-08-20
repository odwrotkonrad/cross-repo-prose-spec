# Feature: Machine-Opened MRs Say So in Their Title

<!-- [>] 🤖🤖 -->

Automation opens merge requests: prose regen fans out one per affected repo.
Other automation must find exactly those: the sweeper landing them on green CI,
the report counting what a release propagated, the query telling a human which
open MRs are theirs.

Nothing marked an MR as machine-opened. Filtering by source branch seemed close
enough, but GitLab's `source_branch_search` matches loosely: a sweep filtered on
`prose-v` also returned hand-written MRs from three unrelated repos. Acting on
that set would have merged human work.

The marker is a fixed `[automation]` title prefix. It survives branch renames,
shows in any list, and matches exactly.

## As an operator

Scans open merge requests across the group. Reviews human work, ignores the
rest.

### Machine work is distinguishable at a glance (implemented)

I want every machine-opened MR titled with an `[automation]` prefix and no
hand-written MR carrying it,
so that a list read separates what needs review from what does not.

## As a workspace maintainer

Writes automation that acts on other automation's MRs.

### Automation never touches human work (implemented)

I want selection matched on the `[automation]` title prefix, not a branch-name
pattern,
so that a loose branch match cannot again pull in hand-written MRs.

### The marker survives rewriting tools (implemented)

I want the prefix intact through branch renames and reopens,
so that matching on it keeps finding the MR.

### A retitled MR regains its marker (todo)

I want the prefix re-asserted on a machine-opened MR whose title lost it,
so that a hand retitle cannot hide the MR from the sweep.

<!-- [<] 🤖🤖 -->
