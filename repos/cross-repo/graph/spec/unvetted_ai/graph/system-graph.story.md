# Feature: The System Graph Is A Repo Of Data

<!-- [>] 🤖🤖 -->

The graph describes every repo in the group. Kept beside automation's code, the
record of what the system looked like over time is interleaved with refactors,
test changes and dependency bumps, so it cannot be read as history.

Three files, at the root of `cross-repo/graph`, all in the same
`artifacts:` + `depends_on:` syntax each repo already uses:

- `bare-system-graph.yml`: artifacts and dependencies, no versions.
- `desired-system-graph.yml`: bare plus the version each upstream should be.
- `current-system-graph.yml`: bare plus the version each upstream is.

Convergence is the two versioned files matching. Between an upstream release
and the last consumer adopting it they differ, and the system is visibly
unconverged.

The repo holds no generator, no tests and no release. automation clones it,
writes the files and commits. Its only pipeline job is the shared one every
repo runs to emit events.

## As a workspace maintainer

Reads the graph to understand the system. Hand-edits none of it.

### Read the system's history as a commit log (todo)

I want the graph in a repo carrying data and nothing else,
so that `git log` is a chronological record of the system and `git diff`
between two commits answers what changed in it.

### See at a glance whether the system has converged (todo)

I want the version each consumer should hold and the version it does hold in
two files of identical shape,
so that a diff of the two answers convergence with no interpretation.

### Answer the whole dependency structure from one place (todo)

I want artifacts and their dependencies in one generated graph,
so that what depends on what is a lookup, not a survey of twelve repos.

### Learn one syntax, not two (todo)

I want the graph's `depends_on:` block to be the same shape a repo declares,
so that a block moves between the two unchanged and one parser serves both.

### Trust that nothing lives only in the graph (todo)

I want the whole graph rebuildable from the repos' declarations alone,
so that deleting all three files and regenerating restores them exactly.

### Catch a dependency cycle when it is written (todo)

I want generation to fail naming the full cycle path,
so that a circular dependency is a build error rather than a runtime loop.

## As an agent working in the graph repo

Writes the files on automation's behalf. Adds nothing else.

### Keep the repo free of everything but data (todo)

I want the tracked files limited to the three graph files, the shared event
job, the README and the licence,
so that no generator, test or extra pipeline job creeps back in and spoils the
history.

### Write commit messages a human reads (todo)

I want each commit to name the event and what moved, in a fixed template,
so that the log is legible without opening a diff.

<!-- [<] 🤖🤖 -->
