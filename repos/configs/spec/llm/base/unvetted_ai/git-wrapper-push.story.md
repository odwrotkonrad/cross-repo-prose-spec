# Feature: git wrappers push rebased branches without losing work

<!-- [>] 🤖🤖 -->

## As a workspace maintainer

Rebases branches onto main across many repos, does not push them by hand.

### A rebased branch still reaches its remote (implemented)

I want a non-fast-forward rejection answered by re-fetching the remote branch,
comparing with `git cherry`, and retrying with `--force-with-lease` pinned to
the fetched tip when no remote-only commits exist, then upserting the MR,
so that rebasing onto main does not cost a manual push per repo.

### An unchanged branch costs no llm call (implemented)

I want a branch whose remote tip equals HEAD with an MR already open exiting 24
before any MR text is requested, checked before the push so a repeat run costs
one fetch and one list call, while a branch with no open MR still proceeds,
so that a fan-out re-describes only what moved.

## As an agent

Drives the wrappers unattended, cannot judge a conflict, must never destroy
work.

### A remote holding unseen commits is never overwritten (implemented)

I want a rejected push whose remote branch carries a commit `git cherry` marks
`+` refusing to force, printing that the remote holds commits absent here and
exiting 1 into the log,
so that automation never discards work it did not author.

### The lease pins the tip actually inspected (implemented)

I want the force-with-lease naming the fetched tip rather than a stale tracking
ref, so a push landing between fetch and retry invalidates the lease,
so that a concurrent session's commit cannot be clobbered by a stale
equivalence check.

### A first push with no remote branch fails plainly (implemented)

I want a rejected push with nothing to compare exiting 1 with the push failure,
so that no branch is forced into existence.

<!-- [<] 🤖🤖 -->
