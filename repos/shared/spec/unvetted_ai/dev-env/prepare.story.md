# Feature: Prepare A Repo's Dev Environment

<!-- [>] 🤖🤖 -->

A clone is not a working checkout. Purpose docs, `AGENTS.md`, `CLAUDE.md` and the
shared `ci/` scripts are gitignored generated output, git hooks are not
installed, and dependencies are absent. Every repo already carries the steps that
fix this, under two naming schemes and in no defined order.

One target per repo, `repo-prepare-dev-env`, chains them: render, then
dependencies, then hooks. The order is not free. The `docsgen` pre-commit hook
runs `render-templates` and fails on drift, so hooks installed before the first
render leave a fresh clone unable to commit.

Toolchains are declared, never assumed. A repo needing ruby, python or terraform
says so in its own che profile, so no environment has to be pre-loaded with every
language a workspace might contain.

## As a developer

Clones a repo and starts working. Runs no per-repo setup ritual.

### One command turns a clone into a working checkout (todo)

I want `repo-prepare-dev-env` in every repo, rendering generated files,
installing dependencies, then installing git hooks,
so that a fresh clone is ready without knowing which steps that repo needs.

### The first commit in a fresh clone passes its hooks (todo)

I want rendering ordered before hook installation,
so that the docsgen hook never fails on a checkout whose generated files were
never rendered.

### The same command works in every repo (todo)

I want one target name across repos whose underlying steps are named differently,
so that preparing a repo needs no reading of its Makefile.

### Preparing twice changes nothing (todo)

I want each step to be an upsert,
so that re-running on a prepared checkout is safe and quiet.

## As a repo maintainer

Owns one repo's Makefile and che profile. Declares what the repo needs.

### A repo states the tools it needs (todo)

I want the toolchain declared as an installable set in the repo's own che
profile, installed before the dependency step that uses it,
so that a repo carries its own requirements instead of assuming the host has them.

### A repo with nothing to install still prepares (todo)

I want the dependency step to be optional, repos without one chaining only render
and hooks,
so that the target is uniform without inventing work for repos that need none.

### Build outputs are not mistaken for prerequisites (todo)

I want only real prerequisites in the chain, never a target that produces
artifacts,
so that preparing an environment does not become building the project.

<!-- [<] 🤖🤖 -->
