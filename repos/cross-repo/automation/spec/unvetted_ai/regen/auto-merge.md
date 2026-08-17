# Feature: Prose Regen MRs Land Without a Human

<!-- [>] 🤖🤖 -->

A prose release fans out one regen MR per affected repo: a pin bump plus
whatever `make render-templates` regenerated. Patch and minor bumps carry no
decision. The content is generated, the diff is mechanical, and clicking merge
on each of eight repos adds only delay.

`scripts/regen/regen.zsh` arms auto-merge on the `glab mr create` call itself,
not afterwards: GitLab attaches the pipeline a second or two after the MR exists,
so every after-the-fact attempt races that gap and gets a 405.

An MR that still ends up with auto-merge unset is caught by
`scripts/regen/sweep.zsh`, which sweeps every open `prose-v*` regen MR and arms
the ones whose pipeline has since gone green. Merging outright, with no pipeline
gate, is reserved for a repo that provably runs no merge-request pipeline. A
slow, queued or failing pipeline is never mistaken for an absent one. Anything
the run declines to merge is left open and reported.

Scenario: a mechanical prose bump merges itself once CI is green
  Status: implemented
  Given a regen MR for a patch or minor prose bump
  When its pipeline succeeds
  Then the MR merges without anyone clicking
  And its source branch is deleted
  And a major bump still waits for a human

Scenario: auto-merge is never traded for an unguarded merge
  Status: implemented
  Given the script cannot get GitLab to accept auto-merge
  When it falls back
  Then it merges outright only for a repo that genuinely runs no merge-request pipeline
  And a repo whose pipeline exists but is slow, queued or failing is never merged unguarded
  And an MR it declines to merge is left open and reported, not silently abandoned

Scenario: an MR that missed its auto-merge window still lands
  Status: implemented
  Given a regen MR left open with auto-merge unset, because its pipeline was late or briefly unmergeable
  When the pipeline later goes green
  Then the MR still merges without a human
  And an MR whose pipeline went red stays open for someone to look at

Scenario: a failed regen pipeline is visible, not just an MR that never moved
  Status: implemented
  Given a regen MR whose pipeline failed
  When the fan-out finishes
  Then the run reports which repos landed and which did not, with the reason
  And a red pipeline is distinguishable from a merge that was never attempted

<!-- [<] 🤖🤖 -->
