# Feature: Prepare A Repo's Dev Environment

<!-- [>] 🤖🤖 -->

A clone is not a working checkout. Purpose docs, `AGENTS.md`, `CLAUDE.md` and
the shared `ci/` scripts are gitignored generated output, hooks are not
installed, dependencies are absent. Every repo already has the steps that fix
this, under two naming schemes and in no defined order.

One target per repo, `repo-prepare-dev-env`, chains them: render, dependencies,
hooks. Order matters: the `docsgen` pre-commit hook runs `render-templates` and
fails on drift, so hooks installed before the first render leave a fresh clone
unable to commit.

Toolchains are declared, never assumed. A repo needing ruby, python or
terraform says so in its own che profile, so no environment is pre-loaded with
every language the workspace contains.

## As a developer

Clones a repo and starts working. No per-repo setup ritual.

### One command turns a clone into a working checkout (implemented)

I want `repo-prepare-dev-env` in every repo, rendering generated files,
installing dependencies, then git hooks,
so that a fresh clone is ready without me knowing which steps that repo needs.

### The first commit in a fresh clone passes its hooks (implemented)

I want rendering ordered before hook installation,
so that the docsgen hook never fails on a checkout never rendered.

### che-packages installs hooks (todo)

I want che-packages carrying `lefthook.yml` and closing its chain with
`repo-ci-prepare-hooks`,
so that its first commit meets the docsgen hook like every other repo's.

### The same command works in every repo (implemented)

I want one target name across repos whose underlying steps differ in name,
so that preparing a repo needs no reading of its Makefile.

### Preparing twice changes nothing (implemented)

I want each step to be an upsert,
so that re-running on a prepared checkout is safe and quiet.

## As a repo maintainer

Owns one repo's Makefile and che profile. Declares what the repo needs.

### A repo states the tools it needs (implemented)

I want the toolchain declared as an installable set in the repo's own che
profile, installed before the dependency step using it,
so that a repo carries its own requirements instead of assuming the host has
them.

### Every toolchain is declared (todo)

I want notes (ruby), sandbox (podman, kind, kubectl, cilium), automation (glab,
yq) and configs (che, go via script) carrying a `devEnv` profile,
so that no host needs pre-loading to prepare them.

### A repo with nothing to install still prepares (implemented)

I want the dependency step optional, repos without one chaining only render and
hooks,
so that the target stays uniform without inventing work.

### Build outputs are not mistaken for prerequisites (implemented)

I want only real prerequisites in the chain, never a target producing
artifacts,
so that preparing an environment never becomes building the project.

<!-- [<] 🤖🤖 -->
