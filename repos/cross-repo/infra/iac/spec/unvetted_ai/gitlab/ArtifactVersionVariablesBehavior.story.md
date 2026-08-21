# Feature: Artifact versions are declared once, as group variables

<!-- [>] 🤖🤖🤖 -->

Repos consume each other's released artifacts: prose tags, the che-packages
tarball, che binaries, images. Each version used to sit inline in every
consumer, sed-bumped by regen MRs. `che_packages_ref` escaped that first: one
tfvars line, one `GRP_KO_VAR_CHE_PACKAGES_REF` group variable, one line to
bump. Every artifact gets the same. Prose came next, now as three pins
(`PROSE_ASSETS_REF`, `PROSE_SPEC_REF`, `MISC_REF`, see automation's
`sync/multi-producer-pins.story.md`). The lowercase `<artifact>_ref` tfvars
keys rename to the bare variable name `<NAME>` under
`ci/ci-var-events.story.md`.

## As an infra operator

Declares the group's CI variables in terraform. Does not edit consumers.

### One tfvars line per artifact carries its version (implemented)

I want each artifact's version as its own `<artifact>_ref` line in
`terraform.tfvars`, threaded into the gitlab module beside `che_packages_ref`,
so that bumping any artifact is one reviewable line in one repo.

### Each version is published as a prefixed group variable (implemented)

I want a `gitlab_group_variable` keyed `GRP_KO_VAR_<ARTIFACT>_REF` per
artifact, unmasked and unprotected (a version string, MR pipelines need it),
consumers deriving the bare name at the pipeline boundary,
so that every pipeline and every local seed reads one value, named by its
scope, always the latest release.

### Bump MRs land here, carried by automation (implemented)

I want automation to open the bump MR against this repo's tfvars line on every
producer release, the user applying it under their own identity,
so that per-consumer pin rewriting retires and no consumer can disagree about
the current version.

<!-- [<] 🤖🤖🤖 -->
