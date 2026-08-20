# Feature: Che Packages

<!-- [>] 🤖🤖 -->

Scenario: --update refreshes everything (implemented)
  When I invoke `che packages install --update`
  Then unpinned installed packages update via their manager (brew upgrade, apt-get install --only-upgrade, npm update -g)
  And pinned packages still converge on the pin

Scenario: --if-missing fills only the gaps (tested)
  When I invoke `che packages install --if-missing`
  Then a package whose canonical command exists anywhere on PATH is skipped, regardless of manager

Scenario: --only-methods restricts installs to chosen methods (implemented)
  When I invoke `che packages install --only-methods <mgr>[,<mgr>...]` (env `CHE_PACKAGES_ONLY_METHODS`)
  Then only items using a listed manager are considered, nothing falls through to another installer
  And a package with no listed manager applicable skips with `no applicable installation method`
  And an unknown manager name fails validation

Scenario: a dry run announces installs without touching the host (tested)
  When I invoke an install under --dry-run
  Then each pending package announces `install <pkg> via <mgr> (dry run)`
  And no manager install command runs

Scenario: binariesRemoteArchive downloads cache across runs (implemented)
  When I invoke an install with `--download-cache-dir <dir>` (env `CHE_PACKAGES_DOWNLOAD_CACHE_DIR`)
  Then assets download to `<dir>/<sha256(url)>-<basename>` and later installs reuse them without curl
  And a checksum mismatch deletes the cached file before failing
  And an empty value keeps the per-install temp-dir behavior

Scenario: a user audits presence with check-present (tested)
  When I invoke `che packages check-present [pkg...]`
  Then each canonical command's PATH presence reports
  And any missing command fails the command

Scenario: a user spots drift with check-upgradable (tested)
  When I invoke `che packages check-upgradable`
  Then manager-reported outdated packages warn (brew outdated, apt list --upgradable, npm outdated -g)
  And binariesRemoteArchive entries whose --version output lacks the yaml pin warn

Scenario: a user spots PATH shadowing with check-not-shadowed (tested)
  When I invoke `che packages check-not-shadowed`
  Then a package whose manager-expected binary is not the first PATH hit warns `shadowed by <path>`

Scenario: a user spots duplicate installs with check-single-present (tested)
  When I invoke `che packages check-single-present`
  Then a canonical command present in more than one PATH dir warns `multiple-present` listing every location

Scenario: an install run ends proving the commands exist (implemented)
  When `che packages install` finishes a real run
  Then check-present runs over the installed set and warns on missing commands
  And no other check runs automatically

Scenario: packages.yml ships a json schema of its structure (implemented)
  When `make render-docs` runs
  Then it generates `assets/data/packages.schema.json` from the Go source, alongside che.schema.json, published with the docs
  And a packages file opens with a `# yaml-language-server: $schema=<url-or-path>` modeline pointing at it, so yaml-aware editors validate and complete in place
  And the builtin packages.yml carries that modeline against the published schema url

<!-- [<] 🤖🤖 -->
