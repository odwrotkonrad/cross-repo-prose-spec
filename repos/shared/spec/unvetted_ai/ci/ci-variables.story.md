# Feature: Every CI variable says where it comes from and is read once

<!-- [>] 🤖🤖 -->

A GitLab-injected variable carries a prefix naming its scope:
`GRP_<MNEMONIC>_VAR_` for a group (`GRP_KO_VAR_` for `konradodwrot`),
`REPO_VAR_` for a project. All are declared in `infra/iac`. Each pipeline
remaps every injected variable it consumes to the bare name at the boundary,
and everything past the boundary reads the bare name. A tracked
`.env.tpl` at the repo root lists those bare names, so a host seeds the
same environment CI derives. Convention:
`conventions/ci-variables/convention.md`.

## As a pipeline reader

Opens a `.gitlab-ci.yml` or a CI script and needs to know where a value
comes from, without GitLab.

### The group prefix names the group (implemented)

I want a group variable keyed `GRP_<MNEMONIC>_VAR_<NAME>`, the mnemonic
taken from the table in the convention (`konradodwrot` → `KO`),
so that `GRP_KO_VAR_CI_IMAGES_REF` tells me which group to open to change
it, and a second group's variables cannot be mistaken for the first's.

### The project prefix stays bare of a name (implemented)

I want a project variable keyed `REPO_VAR_<NAME>`, no repo mnemonic,
so that the scope is readable and the key does not restate the repo it is
only visible in.

### One remap line per variable, at the top of the pipeline (implemented)

I want each group variable a pipeline consumes assigned to its bare name in
the top-level `variables:` block, and each project secret assigned on the
job that uses it,
so that the scope of every value is visible where it enters, and nothing
further in carries a prefix.

### Jobs and scripts read bare names only (implemented)

I want no `$GRP_` or `$REPO_VAR_` reference outside a remap line: jobs,
`ci/*.zsh`, Makefiles, and pipelines emitted by scripts read the bare name,
so that a script runs the same under GitLab and from a host `.env`, and a
prefix rename touches remap lines only.

## As a repo owner

Runs the repo's CI scripts locally and keeps its pipeline in sync with the
variables it reads.

### `.env.tpl` mirrors the remap block (implemented)

I want a tracked `.env.tpl` at the repo root, the one template `.env`
renders from (`dev-env/env-template.story.md`), carrying every bare name the
pipeline derives, each fetched with `{{ shell "glab variable get ..." }}`,
so that a checkout and CI read the same value from the same GitLab variable,
and a variable added to the pipeline is added to the template in the same
change.

### A test suite never inherits a behaviour switch (implemented)

I want a variable that changes a tool's default (`CHE_BACKUP_AUTO_CREATE`)
remapped on the jobs that want it, never top-level,
so that adding a test job cannot silently inherit a disabled feature.

## As an infra operator

Declares every CI variable in `infra/iac`. Does not edit pipelines.

### Every key in GitLab is a resource in iac (implemented)

I want every group and project variable declared as a
`gitlab_group_variable` or `gitlab_project_variable` in `infra/iac`,
so that nothing is clicked into the UI.

### Drift between GitLab and iac is caught (todo)

I want a job listing variables over the group and every project and diffing
them against the terraform state, an unmanaged key imported or deleted,
so that a clicked-in value cannot outlive the next pipeline.

### The bare name is never defined in GitLab (implemented)

I want GitLab to hold only prefixed keys,
so that one value has one home and the derivation stays a reviewed line in
the pipeline.

### A prefix rename keeps every pipeline green (implemented)

I want a renamed group prefix rolled out in three steps: iac adds the new
keys beside the old, every consumer switches, iac drops the old,
so that no pipeline reads a key that does not exist yet.

<!-- [<] 🤖🤖 -->
