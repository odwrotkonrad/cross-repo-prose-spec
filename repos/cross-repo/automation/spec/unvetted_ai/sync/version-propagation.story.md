# Feature: One Place Carries Versions Between Repos

<!-- [>] 🤖🤖 -->

Repos consume each other's releases: go-modules embeds the che-packages
catalog, every repo renders prose at a pinned tag, images bake a che build.
Each of those is a version written down in the consumer, and each has to move
when the producer publishes.

prose already works this way. A tag fans out one regen MR per affected repo,
the pin rises there, and the consumer's own CI proves the new version before
anything merges. Nothing else does. The catalog pin sat at `0.0.4` while the
catalog shipped `0.0.7`, and pointed at a registry the catalog had already
left, silently, because no mechanism was watching and no one had reason to
look.

Pinning is deliberate: a build must embed an exactly known version, and
adopting a newer one must be a reviewable change that runs the consumer's
tests first. The gap is not the pin, it is that nothing moves it. control is
where that belongs: it already owns the dependency graph, knows which repos
consume what, and opens the MRs.

A pinned version also belongs in a file of its own, read where it is needed
rather than repeated at each use. One line to change, one place to look, and
no consumer that quietly disagrees with another about which version is
current.

## As a consumer repo owner

Pins producers' versions and builds against them. Does not track their release
streams.

### A pin is one line in one file (implemented)

I want the version declared in its own file, read by everything that needs it,
never inline in a script, a pipeline or a Makefile,
so that knowing or changing it is a single edit in a single place.

### A commit's output never changes under it (implemented)

I want the build to fetch and embed exactly the declared version, whatever the
producer published since,
so that two builds of one commit are byte-identical.

### A bump proves itself before adoption (implemented)

I want the pin-bump MR to run the consumer's own tests against the new version,
merging without a human when green,
so that a breaking bump leaves a red MR rather than a broken default branch.

### Every pin in the repo moves together (implemented)

I want a bump to raise every pin of that producer wherever it is written,
so that a pin in an unexpected file is not silently left behind.

### Disagreeing pins are reported (todo)

I want two pins of one producer holding different versions named in the run's
report,
so that a pin that drifted apart is seen rather than overwritten unnoticed.

### Every released artifact version is carried to iac, published as a variable (implemented)

I want each producer release (a prose tag, a che-packages tarball, an image)
to reach `infra/iac` through control as one MR bumping that artifact's tfvars
line, iac publishing it as a `GRP_KO_VAR_<ARTIFACT>_REF` group variable holding
the latest version, consumers reading the variable and receiving only a content
regen,
so that every artifact's current version has one home, GitLab variables always
name the latest, and no consumer carries a pin to sed.

### A che release is carried like every other artifact (todo)

I want a che tag to reach iac as a tfvars bump published as a group variable,
so that consumers pin che through the same variable mechanism as prose and the
catalog.

## As a workspace maintainer

Owns control's graph and fan-out. Keeps no hand-written consumer lists.

### A publish reaches every consumer automatically (implemented)

I want control to open a pin-bump MR against every repo the graph says consumes
the producer, and none that do not,
so that correctness never depends on remembering the consumer list.

### A stale pin is reported, not discovered by failure (implemented)

I want the prose pin named with the latest tag whenever it lags,
so that staleness surfaces before a consumer breaks on missing content.

### Every producer's stale pin is named, a moved registry included (todo)

I want the gap named (repo, pin, version available) for every producer when
control evaluates the graph, including a pin aimed at a registry or project the
producer has left,
so that no catalog or image pin rots unseen.

### The consumer list follows declarations alone (implemented)

I want a repo's own interface file to decide what it receives, overriding any
seed,
so that no edit inside control is needed to onboard a consumer.

### Dropping a consumer needs no edit inside control (todo)

I want the seeds gone once every repo declares itself,
so that removing an interface file drops a consumer with no seed resurrecting
it.

<!-- [<] 🤖🤖 -->
