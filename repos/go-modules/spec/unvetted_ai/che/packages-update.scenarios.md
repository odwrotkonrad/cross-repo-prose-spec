# Feature: Che Packages Definitions Update

<!-- [>] 🤖🤖 -->

Scenario: a host picks up new definitions without a che upgrade (tested)
  When I invoke `che packages update`
  Then che resolves the latest published che-packages version from `latest/version.txt`
  And downloads that version's tarball, verifies its sha256 against `checksums.txt`
  And extracts `packages.yml` + `scripts/` atomically into `<cache>/packages/<version>/`
  And marks the version current and prunes older cached versions

Scenario: repeated update invocations stay cheap (tested)
  When I invoke `che packages update` within the cooldown window
  Then the command reports the cached state without touching the registry
  And `--force` re-checks immediately
  And an already-cached latest version refreshes the check stamp and reports up to date

<!-- [<] 🤖🤖 -->
