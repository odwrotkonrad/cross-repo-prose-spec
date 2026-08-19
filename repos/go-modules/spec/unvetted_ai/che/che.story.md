# Feature: Che Profile as a Unit of Execution

<!-- [>] 🤖🤖 -->

## As an operator

Runs che over profiles on a host. Reads the output, does not read the code.

### Profiles run exactly as the discovery log lists them (tested)

I want discovery order to determine execution order,
so that the printed plan is the run.

### A profile with nothing to change costs no time (tested)

I want a zero-delta profile skipped wholesale, announced by a debug
`will not run profile <ref>: no changes` line, config-empty op sets carrying
reason `options.run.skipOps` and undefined ones `not defined`,
so that a settled host reruns fast and says why.

### Naming an op runs it, whatever the run sequence skips (todo)

I want `run.skipOps` to bind to the `run` sequence alone, every direct op
subcommand executing normally even while listed there,
so that invoking an op by name is never silently ignored.

### Each profile's work reads as one uninterrupted block (tested)

I want every discovered os-mutating operation of a profile to complete before
the next profile starts, never interleaving,
so that output and failures attribute to one profile at a time.

### A heading anchors every op line to its profile (tested)

I want a `## Profile <ref>` heading emitted before a profile's ops log,
so that no line is orphaned from its profile.

### One dry-run banner opens the output, no per-line marker (tested)

I want one opening line
`dry run (<mode>) no actual operations will be performed, <desc>`, delta's desc
naming only changing dests and all's every dest, no other line carrying a
marker, `--dry-run=true` aliasing delta,
so that dry-run output reads like real output.

### The plan prints before the work starts (tested)

I want the discovery log to precede execution at every log level showing both,
so that I can stop a run before it touches anything.

### Script failures collect across the run by default (tested)

I want remaining scripts, ops and profiles to run after a script failure, each
script reported `ran` or `failed`, failures joining into the final error,
so that one run surfaces every broken script.

### Errexit aborts at the first script failure (tested)

I want `--errexit` (or `CHE_ERREXIT`) to stop the remaining scripts, ops and
profiles and exit nonzero naming the failed script,
so that a failing script never leaves a half-configured host.

<!-- [<] 🤖🤖 -->
