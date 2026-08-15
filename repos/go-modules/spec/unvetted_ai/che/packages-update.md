# Feature: Che Packages Definitions Update

<!-- [>] 🤖🤖 -->

The builtin package database ships in the `che-packages` module, released and
published to the generic package registry independently of che. `che packages
update` fetches the latest published definitions into the cache dir
(`$XDG_CACHE_HOME/che/packages`); cached definitions supersede the compiled-in
builtin when no user packages file exists.

Scenario: a host picks up new package definitions without a che upgrade
  Status: tested
  When I invoke `che packages update`
  Then che resolves the latest published che-packages version from `latest/version.txt`
  And downloads that version's tarball, verifies its sha256 against `checksums.txt`
  And extracts `packages.yml` + `scripts/` atomically into `<cache>/packages/<version>/`
  And marks the version current and prunes older cached versions

Scenario: installs prefer fresher cached definitions but a user file still wins
  Status: tested
  When packages load for install or inspection
  Then an explicit `--packages-file` supersedes everything
  And a user file at `$XDG_CONFIG_HOME/packages/packages.yml` supersedes the cache
  And the cached current version's `packages.yml` supersedes the compiled-in builtin
  And the compiled-in builtin serves when no user file or cache exists

Scenario: an update check before installs never breaks offline installs
  Status: tested
  When `packages.updateCheck.enabled` is true (default false, env `CHE_PACKAGES_UPDATE_CHECK`)
  Then each installer construction first runs the update flow
  And the check is skipped while the last check is younger than `packages.updateCheck.cooldown` (default 15m, env `CHE_PACKAGES_UPDATE_CHECK_COOLDOWN`)
  And an update failure warns and installs proceed with the current cache or builtin

Scenario: repeated update invocations stay cheap
  Status: tested
  When I invoke `che packages update` within the cooldown window
  Then the command reports the current cached state without touching the registry
  And `--force` re-checks the registry immediately
  And an already-cached latest version refreshes the check stamp and reports up to date

<!-- [<] 🤖🤖 -->
