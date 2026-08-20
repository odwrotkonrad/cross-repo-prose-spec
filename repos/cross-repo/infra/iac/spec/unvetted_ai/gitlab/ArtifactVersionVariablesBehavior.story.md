# Feature: Artifact versions are declared once, as group variables

<!-- [>] 🤖🤖🤖 -->

Repos consume each other's released artifacts: prose tags, the che-packages
tarball, che binaries, images. Each version used to be written inline in every
consumer and sed-bumped by regen MRs. `che_packages_ref` already escaped that:
one tfvars line, one `GRP_KO_VAR_CHE_PACKAGES_REF` group variable, one line to
bump. Every artifact gets the same treatment, prose (`prose_ref`,
`GRP_KO_VAR_PROSE_REF`) first.

## As an infra operator

Declares the group's CI variables in terraform. Does not edit consumers.

### One tfvars line per artifact carries its version (implemented)

I want each artifact's version declared as its own `<artifact>_ref` line in
`terraform.tfvars`, threaded into the gitlab module beside `che_packages_ref`,
so that bumping any artifact is one reviewable line in one repo.

### Each version is published as a prefixed group variable (implemented)

I want a `gitlab_group_variable` keyed `GRP_KO_VAR_<ARTIFACT>_REF` per artifact,
unmasked and unprotected (a version string, needed by MR pipelines),
consumers deriving the unprefixed name at the pipeline boundary,
so that every pipeline and every local seed reads one value, named by its
scope, always the latest release.

### Bump MRs land here, carried by control (implemented)

I want control to open the bump MR against this repo's tfvars line on every
producer release, the user applying it by their own identity,
so that per-consumer pin rewriting retires and no consumer can disagree about
the current version.

<!-- [<] 🤖🤖🤖 -->
