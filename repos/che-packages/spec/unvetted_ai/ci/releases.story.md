# Feature: A Merged Catalog Change Releases Itself

<!-- [>] 🤖🤖 -->

Every consumer reads a published release: go-modules vendors a pinned version
at build time, `che packages update` resolves the moving `latest` alias at
runtime. Nothing reads the default branch, so a merged change never tagged
reaches no one.

go-modules already does this. A merge to its default branch runs a release job
that computes the next version from existing tags and calls `glab release
create`, minting tag and release together. The tag pipeline publishes the
artifacts.

This repo had only the second half. Tags were cut by hand, so a merged change
sat unreleased until someone remembered, and the next version was read off the
tag list. With no release object, the publish job's asset links 404'd and
killed the job before it uploaded `checksums.txt`, the file the vendor step
verifies against. Two releases published a tarball nothing could consume.

## As a catalog maintainer

Merges catalog changes. Decides no version numbers, cuts no tags.

### A merged change ships without anyone remembering to tag (implemented)

I want the default-branch pipeline tagging, releasing and publishing the
tarball, checksums and moving alias,
so that merging is the whole act of shipping.

### The version follows from the tag list, not from memory (implemented)

I want the next version as the highest existing tag with its patch raised,
v0.0.1 on an untagged repo,
so that two releases never collide and nobody reads tags by hand.

### Only catalog content triggers a release (implemented)

I want CI, docs and test-only merges cutting no release, while `packages.yml`,
its referenced scripts, and a fix to the publish script itself do,
so that the tag stream tracks consumable change and a publish fix still ships.

## As a catalog consumer

Vendors a pinned tarball or resolves the moving alias. Verifies checksums.

### A published version is always fetchable and verifiable (implemented)

I want the release object created before anything is attached, a failed link
never costing the artifacts, checksums or alias their upload,
so that no published version lacks the file the vendor step verifies against.

<!-- [<] 🤖🤖 -->
