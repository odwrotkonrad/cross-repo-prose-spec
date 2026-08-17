# Feature: Prose Regen MRs Land Without a Human

<!-- [>] 🤖🤖 -->

A prose release fans out one regen MR per affected repo: a pin bump plus
whatever `make render-templates` regenerated. Patch and minor bumps carry no
decision. The content is generated, the diff is mechanical, and clicking merge
on each of eight repos adds only delay.

`scripts/regen/regen.zsh` already asks GitLab to merge on green. Two gaps leave
MRs open anyway.

First, the request is made once, seconds after the MR is created. GitLab rejects
`merge_when_pipeline_succeeds` with a 405 until the MR's pipeline exists, so the
script retries for 60 seconds. If the pipeline is slow to appear, or the MR is
momentarily unmergeable, every attempt fails and auto-merge is left unset.
Nothing revisits it.

Second, the fallback for that case merges outright, with no pipeline gate. It
exists for repos whose CI never runs on merge requests, but it cannot tell those
from a repo whose pipeline was merely slow. A timeout can merge an MR whose
tests were still running, or had already failed.

Scenario: a mechanical prose bump merges itself once CI is green
  Status: todo
  Given a regen MR for a patch or minor prose bump
  When its pipeline succeeds
  Then the MR merges without anyone clicking
  And its source branch is deleted
  And a major bump still waits for a human

Scenario: auto-merge is never traded for an unguarded merge
  Status: todo
  Given the script cannot get GitLab to accept auto-merge
  When it falls back
  Then it merges outright only for a repo that genuinely runs no merge-request pipeline
  And a repo whose pipeline exists but is slow, queued or failing is never merged unguarded
  And an MR it declines to merge is left open and reported, not silently abandoned

Scenario: an MR that missed its auto-merge window still lands
  Status: todo
  Given a regen MR left open with auto-merge unset, because its pipeline was late or briefly unmergeable
  When the pipeline later goes green
  Then the MR still merges without a human
  And an MR whose pipeline went red stays open for someone to look at

Scenario: a failed regen pipeline is visible, not just an MR that never moved
  Status: todo
  Given a regen MR whose pipeline failed
  When the fan-out finishes
  Then the run reports which repos landed and which did not, with the reason
  And a red pipeline is distinguishable from a merge that was never attempted

<!-- [<] 🤖🤖 -->
