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
left — silently, because no mechanism was watching and no one had reason to
look.

Pinning is deliberate: a build must embed an exactly known version, and
adopting a newer one must be a reviewable change that runs the consumer's
tests first. The gap is not the pin, it is that nothing moves it. control is
where that belongs — it already owns the dependency graph, knows which repos
consume what, and opens the MRs.

A pinned version also belongs in a file of its own, read where it is needed
rather than repeated at each use. One line to change, one place to look, and
no consumer that quietly disagrees with another about which version is
current.

## Where a version lives

Scenario: a reader finds the version in one place, not scattered through scripts
  Status: todo
  Given a repo pins a version of something another repo publishes
  When someone needs to know or change it
  Then the version is declared in its own file, not inline in a script, a pipeline or a Makefile
  And everything that needs it reads it from there
  And changing the pin is a one-line edit to that file

Scenario: a build embeds exactly the version its repo declares
  Status: implemented
  Given a pin file naming a producer's version
  When the consumer builds
  Then it fetches and embeds that version, whatever the producer has published since
  And two builds of the same commit embed byte-identical data
  And a newer release cannot change what an unchanged commit produces

## Moving a version forward

Scenario: a publish reaches every repo that pins it, without anyone remembering
  Status: todo
  Given a producer publishes a release
  When its pipeline finishes
  Then control opens a pin-bump MR against every repo the graph says consumes it
  And a repo that consumes nothing from that producer gets no MR
  And nobody has to know the consumer list to keep it correct

Scenario: a version bump proves itself before it is adopted
  Status: todo
  Given a pin-bump MR against a consumer
  When its pipeline runs
  Then the consumer's own tests run against the new version
  And a bump that breaks the consumer leaves a red MR rather than a broken default branch
  And a green one merges without a human, as prose regen MRs already do

Scenario: a pin that has fallen behind is visible, not silently stale
  Status: todo
  Given a pin naming a version older than the producer's newest
  When control next evaluates the graph
  Then the gap is reported, naming the repo, the pin and the version available
  And a pin pointing at a registry or project the producer has left is reported the same way
  And neither is discovered only when a consumer fails on missing content

Scenario: every pin in a repo moves, not only the ones in the expected file
  Status: todo
  Given a repo pins the same producer in more than one place
  When a bump reaches that repo
  Then every pin of that producer is raised, wherever in the repo it is written
  And a pin in a file the fan-out was not written to look at is not silently left behind
  And a repo whose pins disagree with each other is reported, since one of them is stale by definition

Scenario: the consumer list comes from the graph, never a hand-kept list
  Status: todo
  Given repos declare what they produce and consume in their own interface files
  When a new consumer starts pinning a producer
  Then it starts receiving bump MRs from that declaration alone
  And no list inside control is edited to make that happen
  And a consumer that stops pinning stops receiving them

<!-- [<] 🤖🤖 -->
