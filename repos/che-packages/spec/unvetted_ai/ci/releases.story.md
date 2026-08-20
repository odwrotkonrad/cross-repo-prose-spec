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
before it uploaded `checksums.txt`, the file the vendor step verifies against.
Two releases published a tarball nothing could consume.

## As a catalog maintainer

Merges catalog changes. Does not decide version numbers or cut tags.

### A merged change ships without anyone remembering to tag (implemented)

I want the default-branch pipeline to tag, release, and publish the tarball,
checksums and moving alias,
so that merging is the whole act of shipping.

### The version follows from the tag list, not from memory (implemented)

I want the next version computed as the highest existing tag with its patch
raised, starting at v0.0.1 on an untagged repo,
so that two releases never collide and nobody reads tags by hand.

### Only catalog content triggers a release (implemented)

I want CI, docs and test-only merges to cut no release, while `packages.yml`,
its referenced scripts, and a fix to the publish script itself do,
so that the tag stream tracks consumable change and a publish fix still ships.

## As a catalog consumer

Vendors a pinned tarball or resolves the moving alias. Verifies checksums.

### A published version is always fetchable and verifiable (implemented)

I want the release object to exist before anything is attached, with a failed
link never costing the artifacts, checksums or alias their upload,
so that no published version is missing the file the vendor step verifies
against.

<!-- [<] 🤖🤖 -->
