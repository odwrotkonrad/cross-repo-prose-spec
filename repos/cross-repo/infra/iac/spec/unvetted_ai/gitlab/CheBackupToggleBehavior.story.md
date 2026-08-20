# Feature: Disposable CI hosts stop paying for recovery points

<!-- [>] 🤖🤖 -->

Before mutating a dest, che archives it, so a bad run reverts. On a real host that
archive is the whole safety net. In a container built and thrown away minutes later
it protects nothing: the tarball dies with the layer, having cost a bz2 compression
pass over every file the run touched.

che reads `backup.autoCreate.enabled`, default true. A group variable carries the
CI value, and each pipeline decides whether its own jobs read it.

The decision is per job, never group-wide by default. che's own suites assert that
backups happen: a variable reaching them turns a passing test red, or worse, green
while proving nothing.

## As a CI maintainer

Owns each repo's `.gitlab-ci.yml`. Decides which jobs opt out of archiving.

### Throwaway builds skip work whose product dies with them (implemented)

I want container-build and disposable-host jobs to run che with automatic
backup off,
so that no pipeline minute is spent compressing files that are discarded with
the layer that holds them.

### che's own tests never read the switch (implemented)

I want the variable absent from every job running che's test and e2e suites,
so that the suites asserting backup behaviour keep exercising it and cannot pass
against a disabled feature.

### Opting out is per job, never a repo-wide default (implemented)

I want the remap declared on the jobs that want it rather than in a repo's
top-level `variables:` block,
so that adding a test job to a repo never silently inherits a disabled backup.

### A real host keeps its recovery point (implemented)

I want jobs applying configs to a host that outlives the pipeline to leave
automatic backup on,
so that a bad apply is still revertible where reverting is possible.

### An explicit snapshot still works where it is asked for (implemented)

I want `che backup create` to archive regardless of the switch,
so that a job wanting a recovery point gets one by asking, whatever the default
for automatic archiving.

## As an infra operator

Declares the group's CI variables in terraform. Does not edit pipelines.

### One declared home for the CI value (implemented)

I want the value declared as a group variable in this repo, never clicked into
the UI,
so that what CI runs with is reviewable and changing it is a merge request.

### The prefix says where the value comes from (implemented)

I want the group-scoped name carrying the `GRP_KO_VAR_` prefix and each pipeline
assigning it to the name che reads,
so that a reader at the point of use knows which scope defined it and where to
change it.

<!-- [<] 🤖🤖 -->
