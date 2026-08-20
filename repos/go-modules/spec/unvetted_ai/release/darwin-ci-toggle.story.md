# Feature: Darwin CI Toggle

<!-- [>] 🤖🤖 -->

macOS jobs run on paid SaaS runners and cannot move to the Linux CI cluster (no
Apple hardware on GCP). `ENABLE_DARWIN_CI` turns them off while the cluster is
proven, and back on in one flip. It is a **group-level** CI variable on
`konradodwrot`, declared in `infra/iac` terraform, so one flip governs every
repo. Release and prerelease darwin builds cross-compile on linux
(`CGO_ENABLED=0`), so the toggle never reaches them.

## As a CI maintainer

Controls darwin CI cost across every repo. Edits no per-repo pipeline to do it.

### Darwin cost stops without deleting the jobs (implemented)

I want the darwin test and dry-run jobs gated on `ENABLE_DARWIN_CI` being
`"true"`, their definitions left in place,
so that turning cost off costs no CI config.

### One flip governs every repo (implemented)

I want the toggle declared once as a group variable on `konradodwrot` in
terraform,
so that no repo carries its own copy and one change reaches all pipelines.

### The pipelines it gates can read it (implemented)

I want the variable neither protected nor masked, being a behavior flag and not
a secret,
so that MR-branch pipelines evaluate their rules against it.

### Coverage returns with one variable (implemented)

I want setting it to `"true"` to run every gated darwin job exactly as before
the toggle existed,
so that reversing the decision costs nothing.

### A skipped darwin job is legible (todo)

I want the gating variable to explain the absence in an inspected pipeline,
so that no job appears to have passed without executing.

## As a release consumer

Installs che binaries. Does not know or care which runners built them.

### A release still publishes with darwin CI off (implemented)

I want `publish-che` and `publish-brew-che` to need no job the toggle gates,
so that a `che/v*` tag pipeline is created and publishes whatever the flip says.

### Darwin binaries ship with darwin CI off (implemented)

I want `goreleaser-darwin-che` and `prerelease-darwin-che` cross-compiling on
linux, outside the toggle,
so that a release or prerelease never lacks darwin archives because of a cost
flip.

<!-- [<] 🤖🤖 -->
