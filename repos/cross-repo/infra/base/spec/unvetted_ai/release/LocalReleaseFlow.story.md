# Feature: Releases are cut locally, announced manually

<!-- [>] 🤖🤖 -->

Every other repo in the group releases from CI. This one cannot: the identity
that applies it is the user's, so the outputs worth publishing exist only after
a local apply. `make release` runs on the user's machine and does three things:
mint a tag when an output moved, publish the outputs package to the generic
registry, and leave the announcement to a manual job.

`emit-events` stays manual because a release here can follow a rotation the
user may not want fanned out the same minute. The pipeline's only other job is
`validate`: fmt and validate, no backend, no credentials.

Consumers read the published package, never the state, so nothing reaches CI
until the user cuts the tag.

## As the infra operator

Cuts releases from a local apply.

### Mint a tag only when something consumers see moved (todo)

I want `make release` to mint a tag when a non-secret output changed or
`secrets_hash` moved,
so that a tag marks a change a consumer can observe rather than every apply.

### Publish the outputs as a package (todo)

I want the release to publish `base-outputs` to the generic registry
repository at the minted version,
so that consumers fetch a versioned artifact instead of reading base's state.

### Keep the pipeline to validation (todo)

I want CI to run only `validate`, with no backend and no credentials, plus the
manual `emit-events`,
so that the pipeline holds nothing that could apply and nothing that needs a
credential able to.

### Announce a release when I choose to (todo)

I want `emit-events` to be a manual job I trigger,
so that a release following a rotation fans out when I decide, not the moment
the tag lands.

### Give the publisher exactly two grants (todo)

I want `base-publisher` to hold read on base's state and write on the generic
registry repository, and nothing else,
so that the identity CI holds can publish an artifact and cannot change what
the artifact describes.

<!-- [<] 🤖🤖 -->
