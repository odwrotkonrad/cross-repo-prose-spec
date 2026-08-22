# Feature: A Regen MR Reaches the Notification Feed

<!-- [>] 🤖🤖 -->

A fan-out opens one regen MR per affected repo and, on a patch or minor bump,
merges it within seconds. Nothing announced any of it. The work landed and the
maintainer learned about it by reading `git log` later, if at all.

Every regen MR gets one comment mentioning a reviewer, which puts the MR in
GitLab's todo and notification feed. The comment is notification only, never a
gate: patch and minor bumps still self-merge on green, majors still wait for a
human, review of what landed happens after the merge. So the comment is posted
before auto-merge is armed, and a failed comment call never fails the regen.

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

### A failed comment never fails the regen (implemented)

I want the comment call to tolerate failure and the run to continue,
so that a notes-endpoint problem cannot strand a mechanical bump.

### The mention target can become a review bot (todo)

I want the mention target to be swappable for a review bot rather than a
person,
so that post-merge review of mechanical bumps can move off my notification
feed later without reworking the fan-out.

<!-- [<] 🤖🤖 -->
