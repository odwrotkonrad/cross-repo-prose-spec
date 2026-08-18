# Feature: Installable che Prereleases from MR Pipelines

<!-- [>] 🤖🤖 -->

Scenario: a developer installs an unmerged che change without waiting for a release (implemented)
  Given an open merge request touching `che/`, `che-packages/` or `lib/`
  When its `prerelease-linux-che` and `prerelease-darwin-che` jobs succeed
  Then each uploads its own `che_0.0.0-mr<iid>_<os>_<arch>.tar.gz` to `packages/generic/che/0.0.0-mr<iid>/`
  And `CHE_VERSION=0.0.0-mr<iid>` installs it through the unchanged published `install.sh`
  And the installed binary reports `0.0.0-mr<iid>` from `che --version`

Scenario: a merge request holds one prerelease, always its newest build (implemented)
  Given a merge request whose prerelease jobs have already published
  When a later push to that same merge request runs them again
  Then it publishes under the same `0.0.0-mr<iid>` version, keyed on the iid and never on the commit
  And the re-uploaded archives replace the previous ones at those filenames
  And the registry holds one prerelease version per merge request, no per-commit accumulation
  And a consumer that resolved `0.0.0-mr<iid>` earlier now gets the newer build under that same version

Scenario: a prerelease never masquerades as a release (implemented)
  When a prerelease publishes
  Then it links no release assets, because a merge request has no release
  And it leaves the moving `packages/generic/che/latest/` alias untouched
  And `install.sh` with no `CHE_VERSION` still resolves the newest real release

<!-- [<] 🤖🤖 -->
