# Feature: The Catalog Source Is Configuration

<!-- [>] 🤖🤖 -->

Scenario: a host reads definitions from a source it names (tested)
  Given `packages.source.url` names a generic package registry base
  When I invoke `che packages update`
  Then che resolves versions against that base rather than the compiled-in default
  And the fetched catalog lands in `<cache>/packages/<version>/`

Scenario: a catalog published as a git repository is usable as-is (tested)
  Given `packages.source.url` names a git repository
  When I invoke `che packages update`
  Then che clones that repository
  And extracts `packages.yml` and `scripts/` into the cache under the resolved commit
  And records that version as current

Scenario: a git catalog is held to a branch, tag or commit (todo)
  Given `packages.source.url` names a git repository
  And `packages.source.ref` names a branch, tag or commit
  When I invoke `che packages update`
  Then che clones that repository at that ref

Scenario: an unset source resolves to the catalog's own repo (tested)
  Given no `packages.source.url` is set anywhere in the option cascade
  When I invoke `che packages update`
  Then che resolves versions against the `konradodwrot/che-packages` registry

Scenario: a pinned ref installs the same definitions every run (tested)
  Given `packages.source.ref` names a published catalog version
  When I invoke `che packages update` twice in succession
  Then both invocations fetch that exact version
  And neither resolves `latest/version.txt`
  And neither is short-circuited by the cooldown

Scenario: an unpinned run picks up the newest catalog (implemented)
  Given `packages.autoUpdate.enabled` is unset
  And no `packages.source.ref` is set
  When I invoke `che apply`
  Then che resolves the newest published version before installing
  And installs against the definitions it just fetched

Scenario: repeated unpinned runs stay cheap (implemented)
  Given `packages.autoUpdate.if.refIsLatest.cooldown` is `30s`
  And an update check ran less than 30s ago
  When I invoke `che apply`
  Then che skips the registry round-trip and reports the current cached state
  And an invocation after the cooldown elapses re-checks the registry

Scenario: a multi-profile apply makes one round-trip (tested)
  Given a spec file declaring several profiles that install packages
  When I invoke `che apply`
  Then che performs the update check exactly once
  And every profile installs against the catalog that one check resolved

Scenario: an explicit update always acts (implemented)
  Given an update check already ran during this che execution
  When I invoke `che packages update`
  Then the command performs its own check rather than reusing the earlier result

Scenario: planning offline is a config choice (tested)
  Given `packages.autoUpdate.if.dryRunIsTrue.enabled` is false
  When I invoke `che apply --dry-run`
  Then che performs no update check and emits no update-check line
  And plans against the cached, else embedded, catalog

Scenario: a dead source costs a warning, not a run (implemented)
  Given the configured source is unreachable
  When I invoke `che apply`, and again with `--dry-run`
  Then both runs warn that the update failed
  And both proceed against the cached, else embedded, catalog
  And neither exits non-zero for that reason

<!-- [<] 🤖🤖 -->
