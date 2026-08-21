# Feature: Workspace Repo Preparation

<!-- [>] 🤖🤖 -->

Cloning fills the workspace with repos that are not yet checkouts. The index
that follows inlines each repo's rendered purpose doc, so on a fresh clone
every entry reads `_(no purpose.md)_`: a list of repos saying nothing about any
of them.

A preparation pass runs between cloning and indexing, calling each repo's own
`repo-prepare-dev-env` (specified in
`repos/shared/spec/unvetted_ai/dev-env/prepare.story.md`). Repos own what
preparing means. The workspace only drives it, in order, over whatever was
cloned.

## As a workspace user

Runs the profile on a fresh host or a new sandbox session. Prepares no repo by
hand.

### A cloned workspace is ready to work in (implemented)

I want each cloned repo prepared after the clone, before anything reads it,
so that a new workspace needs no second pass to become usable.

### The map describes the repos it lists (implemented)

I want preparation to run before indexing, each repo's purpose existing when
the index inlines it,
so that a fresh clone yields a map with real purposes, not a list of
unexplained names.

## As a workspace maintainer

Owns the workspace scripts. Encodes no per-repo knowledge in them.

### One repo's failure never costs the whole run (implemented)

I want a failing repo reported and the pass continued, the step itself always
succeeding,
so that one broken checkout cannot abort a session bootstrap or an image
build.

### A repo that cannot be prepared is skipped, not failed (implemented)

I want repos without the target detected and passed over with a reason,
so that adding a repo to the group never breaks the workspace before it adopts
the convention.

### Preparing is separate from indexing (implemented)

I want the credential-free index path to carry no preparation,
so that refreshing the map stays a local read needing no network or toolchain.

<!-- [<] 🤖🤖 -->
