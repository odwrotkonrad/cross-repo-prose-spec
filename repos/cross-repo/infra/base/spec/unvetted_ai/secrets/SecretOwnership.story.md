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

I want a project access token on `cross-repo/automation` published as
`GRP_KO_PROTECTED_VAR_BOT_EMIT_EVENTS_TOKEN`, a protected group variable,
rather than a pipeline trigger token minted per emitting project,
so that every repo announces its releases as one declared identity, replacing
a `REPO_VAR_AUTOMATION_TRIGGER_TOKEN` that existed in no terraform and on no
project, and so silently 404'd every tag pipeline that tried to use it.

Published widely but reaching one project: emitting an event is a write to
automation's pipelines and nothing else. It is deliberately not the maintainer
token automation clones and pushes with, which carries the same words in its
name and far more reach.

### Apply under my own identity, with no key to leak (todo)

I want base applied through application default credentials for my personal
account, never a service account key, given that it is applied only from my
machine,
so that the root minting every identity in the group holds no long-lived
credential of its own, and revoking my access revokes its reach.

### Authenticate every surface as myself, with no stored token (todo)

I want each provider credential taken from my own interactive login rather than
a token stored in a vault: GCP through application default credentials, GitHub
through `gh`, GitLab through `glab`,
so that the root holding every identity in the group stores no credential of its
own, and revoking my access revokes its reach.

Both CLIs hold an OAuth token in the OS keyring, and both providers accept one
as a bearer credential. GitLab's is read with `glab config get token --host
gitlab.com`; `glab auth token` does not exist.

### Carry no credential in a push mirror url (todo)

I want push mirrors authenticated by an SSH deploy key rather than a token
embedded in the mirror url,
so that no credential sits in a field that terraform prints in a plan diff,
which is how a GitHub PAT was exposed and had to be rotated.

The generated public key is readable only from
`GET /projects/:id/remote_mirrors/:mirror_id/public_key` (GitLab 17.9+), for
which the provider exposes no attribute, so it is fetched over http and
registered with `github_repository_deploy_key`.

### Accept that an OAuth token expires (todo)

I want the credential lines in `.env.tpl` to be shell calls rather than stored
values, given that an OAuth token lasts about two hours where a PAT lasted
until revoked,
so that a re-render picks up a fresh token and a long session re-authenticates
the way `gcloud auth login` does, rather than failing mid-apply on an expiry
nobody expected.

### Name a token for what it reaches (todo)

I want every group access token named
`<group>-<purpose>-[protected|unprotected]-<read|read-write>`, replacing names
like `tag-minter` and `sandbox-rw-nodelete`,
so that the token list, which is read when something has gone wrong and shows
nothing but names, answers what subtree it reaches, who holds it, which
branches see it and what it may do.

### Delete a credential variable no terraform declares (todo)

I want every credential variable in GitLab to exist in terraform, and a bare
unprefixed one treated as drift to delete: `GITLAB_TOKEN` sits at group scope
today, protected, masked and hidden, declared nowhere,
so that a variable nothing owns cannot silently shadow the bare name a
pipeline meant to remap for itself.

<!-- [<] 🤖🤖 -->
