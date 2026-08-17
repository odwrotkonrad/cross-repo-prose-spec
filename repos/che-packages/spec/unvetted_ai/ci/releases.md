# Feature: A Merged Catalog Change Releases Itself

<!-- [>] 🤖🤖 -->

Every consumer of this catalog reads a published release: go-modules vendors a
pinned version at build time, and `che packages update` resolves the moving
`latest` alias at runtime. Nothing consumes the default branch directly, so a
catalog change that merges and is never tagged reaches no one.

go-modules already solves this. A merge to its default branch runs a release
job that computes the next version from the existing tags and calls
`glab release create`, which mints the tag and the release together. The tag
pipeline then publishes the artifacts.

This repo had only the second half. Tags were created by hand, which meant a
merged change sat unreleased until someone remembered, and the version to use
next had to be worked out by reading the tag list. It also meant the release
object was missing, so the publish job's asset links 404'd and killed the job
before it uploaded `checksums.txt` — the file the vendor step verifies against.
Two releases published a tarball nothing could consume.

Scenario: a merged catalog change reaches consumers without anyone tagging
  Status: todo
  Given a change merged to the default branch
  When its pipeline runs
  Then the next version is tagged and released automatically
  And the tag pipeline publishes the tarball, its checksums and the moving alias
  And no one has to decide the version or remember to cut it

Scenario: the next version follows from the last, not from memory
  Status: todo
  Given the repo's existing version tags
  When a release is cut
  Then the version is the highest existing one with its patch raised
  And the first release of an untagged repo is v0.0.1
  And two releases never collide on a version

Scenario: a release exists before anything is attached to it
  Status: todo
  Given the publish step links artifacts to a release
  When it runs
  Then the release it links to already exists
  And a link that cannot be made never costs the artifacts, checksums or alias their upload
  And a published version is always one a consumer can verify and fetch

Scenario: a catalog edit alone triggers the release, unrelated changes do not
  Status: todo
  Given a merge touching only CI config, docs or tests
  When its pipeline runs
  Then no release is cut for it
  And a merge touching packages.yml or the scripts it references does cut one
  And a fix to the publish script itself still ships, rather than waiting for an unrelated catalog edit to carry it

<!-- [<] 🤖🤖 -->
