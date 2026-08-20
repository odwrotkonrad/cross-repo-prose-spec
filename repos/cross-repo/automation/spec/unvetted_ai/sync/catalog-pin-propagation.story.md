# Feature: The Catalog Pin Is a Group CI Variable

<!-- [>] 🤖🤖 -->

go-modules pins the catalog in `che/packages-pin.env`, a file inside `che/`.
That location is the whole problem: `release-che` fires on `changes: [che/**/*]`,
so raising the pin cuts a che release carrying no che change. The tag stream
stops tracking che and starts tracking the catalog, and every consumer of che
pays a version bump for data it could have fetched.

Moving the pin out of the tree fixes both halves at once. As a group-wide CI
variable it is not a file, so it matches no `changes:` rule and releases
nothing. It is also already the shape che's own config wants: `CHE_PACKAGES_REF`
feeds `packages.source.ref` with no translation, so CI pins by setting an
environment variable and a local run, where it is unset, floats to latest.

The variable still has to move when the catalog publishes, and
[one place carries versions between repos](version-propagation.story.md) says
where that belongs. A catalog tag triggers control, control evaluates the graph,
and the repo that owns group configuration applies the raise. The pin lives in
terraform, which is the only place group CI variables are ever written.

Companion specs: [version propagation](version-propagation.story.md),
[catalog source configuration](../../../../go-modules/spec/unvetted_ai/che/packages-source.story.md),
[catalog releases](../../../../che-packages/spec/unvetted_ai/ci/releases.story.md).

## As a release maintainer

Owns che's builds and what they embed. Does not own the catalog's contents.

### A catalog bump that releases no binary (implemented)

I want the pin held outside the module tree, matching no pipeline `changes:`
rule,
so that raising it cuts no che release and the tag stream tracks che alone.

### A build still embedding an exactly known catalog (implemented)

I want the release build to vendor exactly the pinned version rather than
whatever is newest,
so that two builds of one commit stay byte-identical.

### The embedded catalog rising with the pin, on the next release (implemented)

I want a che release built after a raise to carry the raised catalog, with no
edit in go-modules,
so that the binary's offline fallback is current without a pin-bump commit.

## As a pipeline maintainer

Owns CI configuration across repos. Owns neither catalog content nor che's code.

### One variable both CI and che already understand (tested)

I want `CHE_PACKAGES_REF` to feed `packages.source.ref` directly, with no
translation step in any pipeline,
so that pinning in CI and pinning in a config file are the same mechanism.

### A local run floating where CI pins (implemented)

I want the variable unset outside CI, che resolving latest there,
so that a developer gets current definitions and CI gets reproducible ones from
one default.

### CI updating definitions only when the pin says so (tested)

I want a job's che to fetch the pinned catalog when the variable names one, and
to skip the check when it does not,
so that pipeline runs never depend on what the registry published mid-run.

## As a workspace maintainer

Owns control's graph and fan-out. Keeps no hand-written consumer lists.

### A catalog release reaching the pin automatically (implemented)

I want a catalog tag to trigger control, control to evaluate the graph and drive
the raise in the repo owning group configuration,
so that no one raises the pin by hand or remembers that it exists.

### The catalog appearing in the graph like any producer (implemented)

I want che-packages declared in the dependency graph with the catalog as its
published artifact and its consumers derived from their own interface files,
so that onboarding the catalog needs no special case in control.

## As a group configuration owner

Owns the terraform describing the GitLab group. Owns no repo's pipeline.

### Group variables changing only through terraform (implemented)

I want the pin declared as a group CI variable in terraform, applied by a
pipeline, never set through the UI,
so that the value in effect is the value in version control.

### A raise being a reviewable change (implemented)

I want the raise to arrive as a change to the declared value, planned before it
applies,
so that which catalog every repo's CI pins to is readable from the diff.

<!-- [<] 🤖🤖 -->
