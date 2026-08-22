# Feature: A Regen MR Reaches the Notification Feed

<!-- [>] 🤖🤖 -->

A fan-out opens one regen MR per affected repo and, on a patch or minor bump,
merges it within seconds. Nothing announced any of it. The work landed and the
maintainer learned about it by reading `git log` later, if at all.

A regen MR whose diff carries more than version bumps gets one comment
mentioning a reviewer, and that reviewer set on the MR, which puts it in
GitLab's todo, notification feed and assigned queue. Both are notification
only, never a gate: patch and minor bumps still self-merge on green, majors
still wait for a human, review of what landed happens after the merge. So both
happen before auto-merge is armed, and a failure in either never fails the
regen.

The reviewer is configuration (`AUTOMATION_REVIEWER`, from the
`REPO_VAR_AUTOMATION_REVIEWER` CI variable), falling back to the workspace owner
when unset.

## As a workspace maintainer

Owns the fan-out scripts. Reviews what landed, after it landed.

### Every regen MR pings a reviewer (implemented)

I want each regen MR to carry a comment mentioning the reviewer, patch and
minor bumps included,
so that a fan-out reaches the notification feed instead of passing silently.

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

### The reviewer is assigned on the MR, not only mentioned (implemented)

I want the same reviewer set as the MR's reviewer whenever the comment is
posted, the handle resolved to a GitLab user,
so that the MR surfaces in the reviewer's assigned queue and not only in the
notification feed.

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
