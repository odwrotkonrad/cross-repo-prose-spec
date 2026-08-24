# Feature: Base applies locally, CI only publishes

<!-- [>] 🤖🤖 -->

One line splits this repo from every other in the group: who applies. `base`
holds the org foundation, every machine identity, and the state buckets the
other roots write to. A pipeline able to apply it could mint itself any
identity in the group, so no pipeline may. Every mutation runs locally under
the user's admin identity.

CI still has one job: read the applied state and publish its outputs as a
release artifact, so downstream repos never read base's state directly. That
job authenticates as `base-publisher`, a service account holding
`roles/storage.objectViewer` on the base bucket and nothing else. It never
applies anything.

The asymmetry is enforced by the SA's permissions, not by discipline. A
`terraform plan` in this pipeline fails on the state lock, because writing the
lock needs object write. That failure is the guardrail working.

## As the infra operator

Applies base locally with an admin identity. Cuts its releases.

### Apply base only from my own machine (todo)

I want no `plan` or `apply` job in this repo's pipeline and no
`resource_group`, unlike every other terraform repo in the group,
so that the identity able to mint identities is mine alone and never a CI
token's.

### Catch an apply path added to CI later (todo)

I want `base-publisher` to hold read-only access to the state bucket, so a
plan or apply job fails on the state lock rather than running,
so that the rule survives someone adding the job the other repos all have.

### See drift before I cut a release (todo)

I want drift detection to be a local `make plan` I run as a habit, documented
in the README,
so that dropping the CI plan job costs visibility I know how to recover rather
than visibility I forget I lost.

## As a downstream repo owner

Consumes base's identifiers. Never reads its state.

### Read base's outputs without touching its state (todo)

I want base's outputs published as a tarball on its semver release, rendered
into my repo by che at a pinned `BASE_REF`,
so that consuming a project id costs no access to the bucket holding every
identity in the group.

### Receive a base change only once it is released (todo)

I want a local apply to reach me only after the user cuts a tag,
so that the user decides when an identity or project change becomes visible to
CI, rather than the next apply deciding for them.

### Trust that the artifact carries no secret (todo)

I want the published tarball to hold only non-secret identifiers: project ids,
folder ids, service account emails,
so that a key or token never travels through a release artifact, staying in
Secret Manager and 1Password and reaching consumers as masked CI variables.

### Name my own state bucket without an output (todo)

I want bucket names to follow `konradodwrot-<repo>-tfstate` by convention,
so that my backend block names its own bucket and the artifact carries one
fewer value.

<!-- [<] 🤖🤖 -->
