<!--[>] 🤖🤖 -->
Feature: git wrappers push rebased branches without losing work

Scenario: a branch rebased onto main still reaches its remote
  Status: implemented
  Given `git-sync-onto-main.zsh` rebased a branch whose commits were already pushed
  And the rewrite left the remote tip a patch-equivalent twin of a local commit
  When `git-mr-upsert.zsh` pushes
  Then the plain push is rejected non-fast-forward, as git intends
  And the wrapper re-fetches the remote branch and compares it with `git cherry`
  And finding no remote-only commits, it retries with `--force-with-lease` pinned to
    the tip it just fetched
  And the MR/PR upsert proceeds against the updated remote
  So the routine cost of rebasing onto main is not a manual push for every repo

Scenario: a remote holding unseen commits is never overwritten
  Status: implemented
  Given a rejected push whose remote branch carries a commit absent from this branch
    (`git cherry` marks it `+`)
  When the wrapper reconciles
  Then it refuses to force, prints that the remote holds commits absent here, exits 1
  And the failure tails into the log for a human to resolve
  So automation never discards work it did not author

Scenario: the lease pins the tip the wrapper actually inspected
  Status: implemented
  Given a force-with-lease retry
  Then the lease names the fetched tip, not the branch's stale tracking ref
  And a push landing between the fetch and the retry invalidates the lease, failing the push
  So a concurrent session's commit cannot be clobbered by a stale equivalence check

Scenario: an unchanged branch costs no llm call and no MR edit
  Status: implemented
  Given a branch whose remote tip already equals HEAD
  And an MR/PR already open for that branch
  When `git-mr-upsert.zsh` runs again
  Then it exits 24 before requesting any MR text, leaving the open MR untouched
  And the check runs before the push, so a repeat run costs one fetch and one list call
  And a branch with no open MR still proceeds, so a deleted or closed MR is recreated
  So fanning the wrapper out over many repos re-describes only what actually moved

Scenario: a first push with no remote branch fails plainly
  Status: implemented
  Given a rejected push for a branch with no counterpart on the remote
  When the re-fetch finds nothing to compare
  Then the wrapper exits 1 with the push failure rather than forcing a branch into existence
<!--[<] 🤖🤖 -->
