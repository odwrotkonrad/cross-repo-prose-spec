# Feature: Prose Regen MRs Land Without a Human

<!-- [>] 🤖🤖 -->

A prose release fans out one regen MR per affected repo: a pin bump plus what
`make render-templates` regenerated. Patch and minor bumps carry no decision.
The diff is mechanical, clicking merge in eight repos adds only delay.

`bin/automation regen` arms auto-merge on the `glab mr create` call itself.
GitLab attaches the pipeline a second or two after the MR exists, so any later
attempt races that gap and gets a 405.

`bin/automation sweep` catches MRs left unarmed: it walks every open `prose-v*`
regen MR and arms those whose pipeline went green. Merging outright, with no
pipeline gate, is reserved for repos that provably run no merge-request
pipeline. A slow, queued or failing pipeline is never mistaken for an absent
one. What the run declines to merge stays open and is reported.

## As a prose author

Cuts prose releases. Does not click merge in eight downstream repos.

### A mechanical bump lands itself on green (implemented)

I want a patch or minor regen MR to merge and delete its branch once its
pipeline succeeds, a major bump waiting for a human,
so that fan-out costs no clicks where no decision exists.

### A missed auto-merge window still lands (implemented)

I want a sweep to arm any open regen MR whose pipeline has since gone green,
leaving red ones open,
so that a late or briefly unmergeable pipeline does not strand the MR.

## As a workspace maintainer

Owns the fan-out scripts and their safety. Reviews what the run declined.

### Auto-merge is never traded for an unguarded merge (implemented)

I want outright merging reserved for repos that provably run no merge-request
pipeline, a slow, queued or failing one never mistaken for an absent one,
so that nothing merges past a gate that exists.

### A declined or failed regen is visible (implemented)

I want the run to report which repos landed and which did not, with the reason,
so that a red pipeline is distinguishable from a merge never attempted.

<!-- [<] 🤖🤖 -->
