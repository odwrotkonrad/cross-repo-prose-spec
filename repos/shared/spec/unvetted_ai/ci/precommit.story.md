# Feature: Pre-Commit Scope Per Context

<!-- [>] 🤖🤖 -->

Every repo runs the same pre-commit hooks over a file set matched to the
moment. A local commit checks what it changes. An MR pipeline checks the
branch's diff against the default branch, with a manual whole-tree sweep. The
default branch runs nothing: its content already passed as an MR.

## As a developer

Commits locally, opens MRs. Configures no hooks.

### A commit waits only on the files it touched (implemented)

I want pre-commit hooks run over staged files alone,
so that untouched files cost the commit nothing.

### che-packages gets the pre-commit job (todo)

I want che-packages carrying the hooks, the `repo-ci-precommit-all` target and
the validate job,
so that its MRs are checked like every other repo's.

### A whole-repo sweep without leaving the MR (todo)

I want a manual job in the validate stage running pre-commit over all files,
never auto-started, never blocking the MR,
so that coverage beyond the branch diff is one click away.

## As a reviewer

Reads MRs, trusts the pipeline verdict. Runs no hooks by hand.

### The whole branch is checked, not just its last commit (todo)

I want hooks run over every file differing between branch and default branch,
so that a violation from an earlier branch commit still fails the pipeline.

## As a CI maintainer

Wires the scopes into pipelines and hooks. Duplicates no hook config per repo.

### The default branch never re-checks merged content (implemented)

I want no pre-commit job on default-branch pipelines,
so that CI pays only where the check can still find something.

### Every default branch skips the sweep (todo)

I want prose, notes, control, resume-md-pdf, oci-images and sandbox gating
their pre-commit job on MR pipelines, as configs, go-modules and iac do,
so that no main pipeline re-runs a check its MR already passed.

### Scopes are named Makefile targets (implemented)

I want CI and git hooks calling a target named for the scope, never a raw
lefthook command,
so that the same invocation runs locally.

<!-- [<] 🤖🤖 -->
