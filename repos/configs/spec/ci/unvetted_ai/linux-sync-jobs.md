# Feature: Linux Sync Jobs in CI

<!-- [>] 🤖🤖 -->

`.gitlab-ci.yml` loads the repo's `root/` tree onto a fresh linux container twice
per merge request: a dry run that resolves every op without touching the host, and
a smoke apply that performs them. Both cover amd64 and arm64. Both extend one
hidden base, so the dry-run toggle is the only thing separating them.

Scenario: an arm64 host is protected from a change only ever proven on amd64
  Status: implemented
  Given the repo claims one `root/` tree loads onto any supported host profile
  When the linux dry run and the smoke apply run on a merge request
  Then each runs once per architecture, on `gke-linux-amd64` and `gke-linux-arm64`
  And an arch-conditional profile, install script, or package method that breaks
    arm64 reddens the pipeline instead of reaching a host

Scenario: one image tag serves both architectures
  Status: implemented
  Given `ci-linux:latest` is published as a multi-arch manifest
  When a linux job starts on either architecture
  Then it pulls that same tag and gets the matching platform
  And no arch-specific image variable exists to drift

Scenario: dry run and apply cannot drift apart
  Status: implemented
  Given both linux jobs previously repeated the same `sudo --preserve-env` script
  When either job's environment, profile, tags, or command changes
  Then it changes once, in the base both extend
  And the jobs differ only by the dry-run toggle, their stage, and the rules
    gating the apply

Scenario: a dry run never reaches into the secret vault
  Status: implemented
  Given a dry run discards everything it renders
  When the linux dry run renders templates carrying `op://` refs
  Then it skips them rather than fetching their values
  And it matches the pre-commit validate job, which already skips them

Scenario: a failing apply is diagnosable without a rerun
  Status: implemented
  When either linux job runs
  Then che debug output is on, so the op sequence lands in the job log on the first run

Scenario: a draft merge request never performs a real apply
  Status: implemented
  Given the smoke apply mutates the container it runs in
  When the merge request is a draft, or the pipeline is not a merge request pipeline
  Then the apply does not run
  And the dry run still runs, on both architectures

Scenario: the two platform pairs read alike
  Status: implemented
  Given macos carries its own dry-run and apply pair
  When a reader compares the linux pair to the macos pair
  Then each pair shares one base holding its script, environment, and gating
  And each pair's two jobs differ only by the dry-run toggle, stage, needs, and
    the draft gate

<!-- [<] 🤖🤖 -->
