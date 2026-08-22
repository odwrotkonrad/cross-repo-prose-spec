# Feature: A Regen MR Reaches a Reviewer

<!-- [>] 🤖🤖 -->

A fan-out opens one regen MR per affected repo and, on a patch or minor bump,
merges it within seconds. Nothing announced any of it. The work landed and the
maintainer learned about it by reading `git log` later, if at all.

Two mechanisms, deliberately scoped apart. Every regen MR gets the reviewer
assigned, so nothing automated lands unattributed. Only an MR whose diff
carries more than version bumps also gets a comment mentioning them, so the
notification stays worth reading instead of firing on every mechanical
fan-out.

Both are notification only, never a gate: patch and minor bumps still
self-merge on green, majors still wait for a human, review of what landed
happens after the merge. So both happen before auto-merge is armed, and a
failure in either never fails the regen.

The reviewer is configuration (`AUTOMATION_REVIEWER`, from the
`REPO_VAR_AUTOMATION_REVIEWER` CI variable), falling back to the workspace owner
when unset.

## As a workspace maintainer

Owns the fan-out scripts. Reviews what landed, after it landed.

### A content-bearing regen MR pings a reviewer (implemented)

I want a regen MR whose diff changes something besides version bumps to carry
a comment mentioning the reviewer, patch and minor bumps included,
so that real content reaches the notification feed instead of passing
silently.

### A version-only regen MR stays silent (implemented)

I want a regen MR whose diff is only version bumps, a pin line or a rendered
`?ref=` header, to carry no comment,
so that the mention stays worth reading instead of firing on every mechanical
fan-out.

### A reworded line that names a version still counts as content (implemented)

I want a line that was reworded while also naming a version to read as
content, compared pairwise with versions stripped from both sides,
so that a real edit is never mistaken for ref churn.

### A skipped comment is reported, not silent (implemented)

I want the job log to record why a comment was skipped,
so that an absent mention is explained rather than indistinguishable from a
bug.

### The comment says what happened and whether to act (implemented)

I want the comment to name the pin, the versions and the bump, and to state
whether auto-merge was armed or withheld,
so that the notification itself says whether action is needed.

### The mention never gates the merge (implemented)

I want patch and minor bumps to keep merging on green with the comment
present, review happening after the merge,
so that a notification does not become an approval step.

### The reviewer is configuration, with an owner fallback (implemented)

I want the mention target read from `AUTOMATION_REVIEWER`, falling back to the
workspace owner when it is unset or empty,
so that an unapplied CI variable never silences or breaks the fan-out.

### Every regen MR is assigned a reviewer (implemented)

I want the reviewer set on every regen MR, ref-only bumps included and
independent of whether the comment is posted, the handle resolved to a GitLab
user,
so that no automated MR ever lands without a named reviewer on it, even the
ones too mechanical to be worth a notification.

### An unresolvable reviewer leaves the MR unassigned (implemented)

I want a handle that matches no GitLab user to leave the MR unassigned with a
line in the job log,
so that a mistyped or retired handle never fails a mechanical bump.

### A failed comment never fails the regen (implemented)

I want the comment call to tolerate failure and the run to continue,
so that a notes-endpoint problem cannot strand a mechanical bump.

### The mention target can become a review bot (todo)

I want the mention target to be swappable for a review bot rather than a
person,
so that post-merge review of mechanical bumps can move off my notification
feed later without reworking the fan-out.

<!-- [<] 🤖🤖 -->
