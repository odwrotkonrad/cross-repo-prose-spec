# Feature: A Release Reaches Only What It Rebuilds

<!-- [>] 🤖🤖 -->

Today a release fans out to every repo the graph says consumes the producer.
Most of them consume it only to build, lint or render docs: nothing they
publish changes, yet each runs a full pipeline and cuts a release. The version
moves everywhere, and so does the noise.

`depends_on:` decides instead. An upstream release rebuilds exactly the
artifacts naming it, and an upstream no artifact names has its version recorded
and nothing more. The precision already exists in the declarations
(`go-modules/che` rebuilds `ci-linux` and `dev-sandbox` but not
`ci-linux-dind`) and is defeated only by three images sharing one variable.

Four events carry this. A producer's release, the variables applied from it,
each consumer recording what it now holds, and any repo changing its
declarations. One terminal job per repo emits every event that pipeline owes,
batched into a single send.

## As a consumer repo owner

Builds against upstream versions. Does not choose when they move.

### Skip the pipeline when nothing I publish changes (todo)

I want an upstream that no artifact of mine is built from to raise my variable
and record the version, running no build and cutting no release,
so that a docs-only or CI-only dependency stops costing a release.

### Rebuild only the artifact that needs it (todo)

I want a release to rebuild exactly the artifacts declaring it in
`depends_on:`,
so that a sibling artifact untouched by the change is not dragged to a new
version.

### Keep what I hold recorded where it can be read (todo)

I want the version I actually hold committed to my repo, not left in a pipeline
log,
so that the system's current state is reconstructible from the repos alone.

## As a producer repo owner

Publishes artifacts. Does not track who consumes them.

### Publish a version without retriggering myself (todo)

I want recording my own released version to run a minimal pipeline that mints
no tag,
so that a release cannot feed back into itself.

### Move one artifact without moving its siblings (todo)

I want each artifact's version carried by its own variable,
so that releasing one image leaves the other images built beside it untouched.

## As a workspace maintainer

Owns the dispatcher and the fan-out. Keeps no hand-written consumer lists.

### Distinguish declaring, consuming and publishing (todo)

I want a changed declaration, a recorded consumed version and a recorded
produced version to arrive as three distinct events,
so that a version bump never rebuilds the structure and a publication never
fans out.

### Send one repo's events in one job (todo)

I want each repo to end its pipeline with a single job emitting every event
that pipeline owes,
so that a commit touching several declarations produces one trigger, not
several.

### Read every event type from one catalogue (todo)

I want every event automation accepts defined in one file, with a catalogue
entry lacking a handler failing the suite,
so that adding a reaction is adding a handler and nothing unhandled passes.

### Find undeclared dependencies without hunting (todo)

I want generation to warn once per produced artifact absent from `depends_on:`,
so that the warning list is the work queue for completing the declarations.

### Answer what variables a repo should have (todo)

I want automation to generate each repo's CI variable declarations from the
graph it already holds and commit them, rather than anyone maintaining that
list by hand,
so that the one component that knows the dependencies is the one that states
them.

### Write generated files with the consumer's own template (todo)

I want the generated shape defined by a template in the repo receiving it, read
at generation time,
so that changing the shape is an edit in the repo that owns it, not in
automation.

### Order the writes so nothing applies ahead of its data (todo)

I want the graph written before the variable declarations, and both before the
apply that publishes them,
so that no apply runs against versions the graph has not yet recorded.

<!-- [<] 🤖🤖 -->
