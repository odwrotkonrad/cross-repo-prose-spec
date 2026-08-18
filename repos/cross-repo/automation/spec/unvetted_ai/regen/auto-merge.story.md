# Feature: Prose Regen MRs Land Without a Human

<!-- [>] 🤖🤖 -->

A prose release fans out one regen MR per affected repo: a pin bump plus
whatever `make render-templates` regenerated. Patch and minor bumps carry no
decision. The content is generated, the diff is mechanical, and clicking merge
on each of eight repos adds only delay.

`scripts/regen/regen.zsh` arms auto-merge on the `glab mr create` call itself,
not afterwards: GitLab attaches the pipeline a second or two after the MR
exists, so every after-the-fact attempt races that gap and gets a 405.

An MR that still ends up with auto-merge unset is caught by
`scripts/regen/sweep.zsh`, which sweeps every open `prose-v*` regen MR and arms
the ones whose pipeline has since gone green. Merging outright, with no pipeline
gate, is reserved for a repo that provably runs no merge-request pipeline. A
slow, queued or failing pipeline is never mistaken for an absent one. Anything
the run declines to merge is left open and reported.

## As a prose author

Cuts prose releases. Does not click merge in eight downstream repos.

### A mechanical bump lands itself on green (implemented)

I want a patch or minor regen MR to merge and delete its branch once its
pipeline succeeds, while a major bump waits for a human,
so that fan-out costs no clicks where no decision exists.

### A missed auto-merge window still lands (implemented)

I want a sweep to arm any open regen MR whose pipeline has since gone green,
leaving red ones open,
so that a late or briefly unmergeable pipeline does not strand the MR.

## As a workspace maintainer

Owns the fan-out scripts and their safety. Reviews what the run declined.

### Auto-merge is never traded for an unguarded merge (implemented)

I want outright merging reserved for repos that provably run no merge-request
pipeline, with a slow, queued or failing one never mistaken for an absent one,
so that nothing merges past a gate that exists.

### A declined or failed regen is visible (implemented)

I want the run to report which repos landed and which did not, with the reason,
so that a red pipeline is distinguishable from a merge never attempted.

<!-- [<] 🤖🤖 -->
