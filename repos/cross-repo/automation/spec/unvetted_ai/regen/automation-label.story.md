# Feature: Machine-Opened MRs Say So in Their Title

<!-- [>] 🤖🤖 -->

Automation opens merge requests: prose regen fans out one per affected repo.
Other automation must find exactly those and no others. A sweeper that lands
them on green CI, a report counting what a release propagated, a query telling a
human which open MRs are theirs to review.

Nothing in an MR marks it as machine-opened today. Filtering by source branch
seemed close enough, but GitLab's `source_branch_search` matches loosely: a
sweep filtered on `prose-v` also returned hand-written MRs from three unrelated
repos. Acting on that set would have merged human work.

A fixed `[automation]` title prefix is the marker. It survives branch renames,
is visible to anyone scanning a list, and matches exactly.

## As an operator

Scans open merge requests across the group. Reviews human work, ignores the
rest.

### Machine work is distinguishable at a glance (todo)

I want every machine-opened MR titled with an `[automation]` prefix and no
hand-written MR carrying it,
so that reading a list separates what needs review from what does not.

## As a workspace maintainer

Writes automation that acts on other automation's MRs.

### Automation never touches human work (todo)

I want selection matched on the `[automation]` title prefix rather than a
branch-name pattern,
so that a loose branch match cannot again include hand-written MRs.

### The marker survives rewriting tools (todo)

I want the prefix intact through branch renames, reopens and retitles,
so that matching on it keeps finding the MR.

<!-- [<] 🤖🤖 -->
