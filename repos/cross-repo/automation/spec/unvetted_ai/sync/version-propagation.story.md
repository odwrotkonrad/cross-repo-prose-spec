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

### A pin is one line in one file (todo)

I want the version declared in its own file, read by everything that needs it,
never inline in a script, a pipeline or a Makefile,
so that knowing or changing it is a single edit in a single place.

### A commit's output never changes under it (implemented)

I want the build to fetch and embed exactly the declared version, whatever the
producer published since,
so that two builds of one commit are byte-identical.

### A bump proves itself before adoption (todo)

I want the pin-bump MR to run the consumer's own tests against the new version,
merging without a human when green,
so that a breaking bump leaves a red MR rather than a broken default branch.

### Every pin in the repo moves together (todo)

I want a bump to raise every pin of that producer wherever it is written, and
disagreeing pins reported,
so that a pin in an unexpected file is not silently left behind.

## As a workspace maintainer

Owns control's graph and fan-out. Keeps no hand-written consumer lists.

### A publish reaches every consumer automatically (todo)

I want control to open a pin-bump MR against every repo the graph says consumes
the producer, and none that do not,
so that correctness never depends on remembering the consumer list.

### A stale pin is reported, not discovered by failure (todo)

I want the gap named (repo, pin, version available) when control evaluates the
graph, including a pin aimed at a registry or project the producer has left,
so that staleness surfaces before a consumer breaks on missing content.

### The consumer list follows declarations alone (todo)

I want a repo to start and stop receiving bump MRs purely by its own interface
file,
so that no edit inside control is needed to onboard or drop a consumer.

<!-- [<] 🤖🤖 -->
