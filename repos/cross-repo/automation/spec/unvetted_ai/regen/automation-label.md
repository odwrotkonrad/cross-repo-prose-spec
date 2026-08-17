# Feature: Machine-Opened MRs Say So in Their Title

<!-- [>] 🤖🤖 -->

Automation opens merge requests: prose regen fans out one per affected repo.
Other automation needs to find exactly those and no others — a sweeper that
lands them when CI goes green, a report that counts what a release propagated,
a query that tells a human which open MRs are theirs to review.

Nothing in an MR today marks it as machine-opened. Filtering by source branch
seemed close enough, but GitLab's `source_branch_search` matches loosely: a
sweep filtered on `prose-v` also returned hand-written MRs from three
unrelated repos. Acting on that set would have merged human work.

A fixed `[automation]` prefix in the title is the marker: it survives branch
renames, is visible to a person scanning a list, and is exact to match on.

Scenario: an operator sees at a glance which MRs a machine opened
  Status: todo
  Given a list of open merge requests across the group
  When a human or a script reads their titles
  Then every machine-opened MR starts with `[automation]`
  And no hand-written MR carries that prefix

Scenario: automation acting on automation never touches human work
  Status: todo
  Given a sweeper that lands regen MRs on green
  When it selects which MRs to act on
  Then it matches the `[automation]` title prefix, not a branch-name pattern
  And an MR a person opened is never selected, whatever its branch is named
  And a loose branch match that would have included human MRs cannot recur

Scenario: the marker survives the tools that rewrite MRs
  Status: todo
  Given a branch renamed, or an MR reopened or retitled by tooling
  When the MR is listed again
  Then the prefix is still there
  And matching on it still finds the MR

<!-- [<] 🤖🤖 -->
