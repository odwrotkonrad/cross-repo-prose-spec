# Feature: Prose Release Propagation

<!-- [>] 🤖🤖 -->

A fresh prose tag triggers the `control` pipeline. Control resolves affected
downstreams from the dependency graph, regenerates each one via its own
`make render-templates`, and opens a bot MR bumping the repo's prose pin. Patch
and minor MRs auto-merge on green CI. Major MRs wait for a human.

## As a prose author

Merges prose changes, never touches a downstream repo.

### Reach every affected downstream unattended (implemented)

I want control to derive the affected downstreams from the dependency graph and
regenerate each with that repo's own render targets,
so that a release lands everywhere without me chasing repos.

## As a downstream repo owner

Reviews what lands in their repo, does not run the propagation.

### Receive a reviewable, deterministic bot MR (implemented)

I want the MR to bump only the prose pin and the rendered outputs, with a fixed
title and description naming old and new versions,
so that I can review it at a glance.

### Take safe updates unattended and hold breaking ones (implemented)

I want pin-bumping regen MRs to auto-merge on green CI for patch and minor
while major bumps wait,
so that routine churn never reaches my review queue and breaking changes always
do.

### A major release holds content-only regens too (todo)

I want the trigger forwarding the previous tag and content-only regens deriving
their bump from it instead of assuming patch,
so that a breaking prose release waits for review in every consumer, not only
where the pin lives.

### Block propagation on a red pipeline instead of shipping a break (implemented)

I want a failing downstream pipeline to leave the MR open for a human,
so that a broken render never merges itself.

## As a pipeline maintainer

Owns the trigger and control jobs, not the prose or the downstream content.

### Get the released tag as a pipeline variable (implemented)

I want the trigger job to forward the released tag into control's pipeline,
so that control resolves it without querying prose and without relying on
job-scoped dotenv crossing pipelines.

<!-- [<] 🤖🤖 -->
