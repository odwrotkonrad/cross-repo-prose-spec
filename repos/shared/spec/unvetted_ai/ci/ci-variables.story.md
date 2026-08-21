# Feature: Every CI variable says where it comes from and is read once

<!-- [>] 🤖🤖 -->

A GitLab-injected variable carries a prefix naming its scope:
`GRP_<MNEMONIC>_VAR_` for a group (`GRP_KO_VAR_` for `konradodwrot`),
`REPO_VAR_` for a project. All declared in `infra/iac`. Each pipeline remaps
every injected variable it consumes to the bare name at the boundary. Nothing
past the boundary sees a prefix. A tracked `.env.tpl` at the repo root lists
the same bare names, so a host seeds the environment CI derives. Convention:
`conventions/ci-variables/convention.md`.

## As a pipeline reader

Opens a `.gitlab-ci.yml` or CI script and needs to know where a value comes
from, without GitLab.

### The group prefix names the group (implemented)

I want a group variable keyed `GRP_<MNEMONIC>_VAR_<NAME>`, mnemonic from the
convention's table (`konradodwrot` → `KO`),
so that `GRP_KO_VAR_CI_IMAGES_REF` tells me which group to open, and two
groups' variables cannot be confused.

### The project prefix carries no name (implemented)

I want a project variable keyed `REPO_VAR_<NAME>`, no repo mnemonic,
so that the scope reads at a glance and the key does not restate the only repo
it is visible in.

### One remap line per variable, at the top of the pipeline (implemented)

I want each consumed group variable assigned to its bare name in the top-level
`variables:` block, each project secret assigned on the job using it,
so that every value's scope is visible where it enters and nothing further in
carries a prefix.

### Jobs and scripts read bare names only (implemented)

I want no `$GRP_` or `$REPO_VAR_` reference outside a remap line: jobs,
`ci/*.zsh`, Makefiles and script-emitted pipelines read the bare name,
so that a script runs the same under GitLab and from a host `.env`, and a
prefix rename touches remap lines only.

## As a repo owner

Runs the repo's CI scripts locally, keeps the pipeline in sync with the
variables it reads.

### `.env.tpl` mirrors the remap block (implemented)

I want a tracked `.env.tpl` at the repo root, the one template `.env` renders
from (`dev-env/env-template.story.md`), carrying every bare name the pipeline
derives, each fetched with `{{ shell "glab variable get ..." }}`,
so that checkout and CI read the same GitLab variable, and a variable added to
the pipeline lands in the template in the same change.

### A test suite never inherits a behaviour switch (implemented)

I want a variable that changes a tool's default (`CHE_BACKUP_AUTO_CREATE`)
remapped on the jobs that want it, never top-level,
so that a new test job cannot silently inherit a disabled feature.

## As an infra operator

Declares every CI variable in `infra/iac`. Edits no pipelines.

### Every key in GitLab is a resource in iac (implemented)

I want every group and project variable declared as a
`gitlab_group_variable` or `gitlab_project_variable` in `infra/iac`,
so that nothing is clicked into the UI.

### Drift between GitLab and iac is caught (todo)

I want a job listing variables over the group and every project, diffing them
against terraform state, an unmanaged key imported or deleted,
so that a clicked-in value cannot outlive the next pipeline.

### The bare name is never defined in GitLab (implemented)

I want GitLab to hold only prefixed keys,
so that one value has one home and the derivation stays a reviewed pipeline
line.

### A prefix rename keeps every pipeline green (implemented)

I want a group prefix rename rolled out in three steps: iac adds the new keys
beside the old, every consumer switches, iac drops the old,
so that no pipeline reads a key that does not exist yet.

<!-- [<] 🤖🤖 -->
