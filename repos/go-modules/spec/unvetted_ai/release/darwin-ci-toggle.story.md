# Feature: Darwin CI Toggle

<!-- [>] 🤖🤖 -->

macOS jobs run on paid SaaS runners and cannot move to the Linux CI cluster (no
Apple hardware on GCP). `ENABLE_DARWIN_CI` turns them off while the cluster is
proven, and back on in one flip. It is a **group-level** CI variable on
`konradodwrot`, declared in `infra/iac` terraform, so one flip governs every
repo. Release-publishing darwin jobs are exempt: disabling them would ship che
without darwin binaries.

## As a CI maintainer

Controls darwin CI cost across every repo. Edits no per-repo pipeline to do it.

### Darwin cost stops without deleting the jobs (todo)

I want the darwin test and dry-run jobs gated on `ENABLE_DARWIN_CI` being
`"true"`, their definitions left in place,
so that turning cost off costs no CI config.

### One flip governs every repo (todo)

I want the toggle declared once as a group variable on `konradodwrot` in
terraform,
so that no repo carries its own copy and one change reaches all pipelines.

### The pipelines it gates can read it (todo)

I want the variable neither protected nor masked, being a behavior flag and not
a secret,
so that MR-branch pipelines evaluate their rules against it.

### Coverage returns with one variable (todo)

I want setting it to `"true"` to run every gated darwin job exactly as before
the toggle existed,
so that reversing the decision costs nothing.

### A skipped darwin job is legible (todo)

I want the gating variable to explain the absence in an inspected pipeline,
so that no job appears to have passed without executing.

## As a release consumer

Installs che binaries. Does not know or care which runners built them.

### A release still publishes with darwin CI off (todo)

I want `publish-che` and `publish-brew-che` to declare optional `needs:` on the
gated `goreleaser-darwin-che`,
so that a `che/v*` tag pipeline is created and ships the linux artifacts rather
than failing to start.

### Missing darwin binaries are a decision, not a surprise (todo)

I want a release cut with `ENABLE_DARWIN_CI` off to carry linux artifacts only,
so that shipping for darwin users visibly requires enabling darwin CI first.

<!-- [<] 🤖🤖 -->
