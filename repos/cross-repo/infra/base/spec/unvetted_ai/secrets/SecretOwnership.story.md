# Feature: Every secret is created here, and none of them leaves

<!-- [>] 🤖🤖 -->

A secret created next to its consumer is created by that consumer's applier,
which then holds the rights to mint it. So no secret is created outside this
root. What differs per secret is only its audience: a human reads it from
1Password, automation reads it from Secret Manager, a pipeline reads it as a
masked CI variable on the project that consumes it.

None of them propagates. The token resource and the CI variable resource sit in
one state, so the value moves between two resources without ever becoming an
output, a tfvars entry or a release artifact.

One value derived from secrets does leave: `secrets_hash`, a hash over all of
them. A hash is not a secret, and it is what makes a rotation visible as a
changed output.

## As the infra operator

Owns every secret in the group. Routes each to its audience.

### Create every secret in one root (todo)

I want no secret resource declared outside this repo,
so that minting a credential needs the admin identity, and no applier can mint
the credential its own pipeline runs as.

### Route a secret by who reads it (todo)

I want each secret's sink chosen by audience: 1Password for personal use,
Secret Manager for automation, a masked CI variable for CI,
so that a reader fetches from the one place its own tooling already reaches.

### Keep a sensitive value out of every output (todo)

I want `terraform output -json` to carry no sensitive value but `secrets_hash`,
so that a value that must stay in terraform cannot leave through the artifact
consumers read.

### Turn a rotation into a release (todo)

I want one output holding a hash over every secret value,
so that rotating a secret changes an output, which is what makes the release
step mint a tag rather than needing me to remember to.

### Rotate without a pin bump (todo)

I want a rotation to rewrite the consumer's CI variable in place,
so that the consumer picks the new value up on its next pipeline, and the tag
records the rotation rather than delivering it.

### Create a CI variable only where CI needs one (todo)

I want a masked CI variable declared only for a consumer that reads it in a
pipeline, not for every identity that exists,
so that the set of CI-visible secrets stays the set CI actually uses.

### Publish one group-scoped identity for emitting events (todo)

I want the `ko-automation` group access token published as
`GRP_KO_PROTECTED_VAR_BOT_AUTOMATION_GITLAB_TOKEN`, a protected group
variable, rather than a pipeline trigger token minted per emitting project,
so that every repo announces its releases as one declared identity, replacing
a `REPO_VAR_AUTOMATION_TRIGGER_TOKEN` that existed in no terraform and on no
project, and so silently 404'd every tag pipeline that tried to use it.

### Delete a credential variable no terraform declares (todo)

I want every credential variable in GitLab to exist in terraform, and a bare
unprefixed one treated as drift to delete: `GITLAB_TOKEN` sits at group scope
today, protected, masked and hidden, declared nowhere,
so that a variable nothing owns cannot silently shadow the bare name a
pipeline meant to remap for itself.

<!-- [<] 🤖🤖 -->
