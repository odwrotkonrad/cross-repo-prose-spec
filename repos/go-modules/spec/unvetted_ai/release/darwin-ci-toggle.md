# Feature: Darwin CI Toggle

<!-- [>] 🤖🤖 -->

macOS jobs run on paid SaaS runners and cannot move to the Linux CI cluster (no Apple
hardware on GCP). `ENABLE_DARWIN_CI` turns them off while the cluster is proven, and back
on in one flip. It is a **group-level** CI variable on `konradodwrot`, declared in
`infra/iac` terraform, so one flip governs every repo. Release-publishing darwin jobs are
exempt: disabling them would ship che without darwin binaries.

Scenario: darwin CI cost stops without deleting the jobs
  Status: todo
  Given `ENABLE_DARWIN_CI` is unset or not `"true"`
  When a pipeline runs in `go-modules` or `configs`
  Then the darwin test and dry-run jobs do not run
  And their definitions stay in the CI config, gated rather than deleted

Scenario: one flip governs darwin CI across every repo
  Status: todo
  Given `ENABLE_DARWIN_CI` is declared once as a group variable on `konradodwrot` in terraform
  When its value changes
  Then every repo's pipelines see the new value
  And no repo carries its own copy of the toggle

Scenario: the pipelines it gates can read the toggle
  Status: todo
  Given the toggle is a behavior flag, not a secret
  When an MR-branch pipeline evaluates its rules
  Then the variable reads there, being neither protected nor masked

Scenario: darwin coverage returns with one variable
  Status: todo
  Given the darwin jobs are gated behind `ENABLE_DARWIN_CI`
  When the variable is set to `"true"`
  Then every gated darwin job runs exactly as it did before the toggle existed

Scenario: a tag pipeline still publishes when darwin CI is off
  Status: todo
  Given `publish-che` and `publish-brew-che` declare `needs:` on the gated `goreleaser-darwin-che`
  And a `needs:` on a rules-excluded job would otherwise block pipeline creation
  When `ENABLE_DARWIN_CI` is not `"true"` and a `che/v*` tag pipeline runs
  Then the pipeline is created and publishes the linux artifacts
  And the darwin build is skipped rather than blocking the release

Scenario: shipping without darwin binaries is a deliberate choice, not a surprise
  Status: todo
  Given darwin archives are built only by a job that runs on darwin
  When a release is cut with `ENABLE_DARWIN_CI` not `"true"`
  Then that release carries linux artifacts only
  And cutting a release for darwin users requires enabling darwin CI first

Scenario: a reader can tell why a darwin job was skipped
  Status: todo
  Given a pipeline where darwin jobs did not run
  When someone inspects the pipeline
  Then the gating variable explains the absence
  And no job appears to have passed silently without executing

<!-- [<] 🤖🤖 -->
