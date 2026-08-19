# Feature: Che Backup Operation

<!-- [>] 🤖🤖 -->

Scenario: a user picks a restore point from a newest-first listing (tested)
  When I invoke `backup ls`
  Then it lists each ledger-recorded backup point under a `# backups` heading
  And each entry shows run id, backup id, timestamp, size, abbreviated path
  And the newest backup point lists first
  And no backup points lists nothing

Scenario: a user undoes one whole run with a single run id (tested)
  When I invoke `backup restore --run-id <id>`
  Then it restores that run's backup archives exactly
  And a run id matching no run fails with a clear error

Scenario: a user restores one archive without touching the rest of its run (tested)
  When I invoke `backup restore --backup-id <id>`
  Then it restores the single archive whose filename carries that backup id
  And a backup id matching no archive fails with a clear error

Scenario: a user rolls the host back to a chosen moment (tested)
  When I invoke `backup restore --timestamp <ts>`
  Then each dest restores to the most recent backup at or before the timestamp
  And a dest with no backup at or before the timestamp is left as-is
  And a timestamp before every backup fails with a clear error (nothing to restore)

Scenario: a user recovers pre-run state, drifted files never clobbered (tested)
  When I invoke `backup restore` with a selector matching a known archive
  Then every entry in the archive restores onto its recorded dest
  And exactly one of `--run-id`, `--backup-id`, `--timestamp` must be passed, else a clear error
  And a dest that drifted from che's last recorded state is skipped, not clobbered
  And dry run reports each restore as `restore <dest> (dry run)`, writing nothing
  And an unreadable archive fails with a clear error

Scenario: a user snapshots on demand, settled dests skipped (tested)
  When I invoke `backup create` standalone
  Then every existing dest an op would change archives into the per-run archive
  And settled dests are not archived
  And nothing to change archives nothing

Scenario: a disposable host runs with no archive written (todo)
  Given `backup.autoCreate.enabled` is false
  When I invoke `run`
  Then no archive is written under the state dir
  And every op still performs its mutations
  And a debug line names the option as the reason the stage was skipped

Scenario: a directly invoked op honours the same switch (todo)
  Given `backup.autoCreate.enabled` is false
  When I invoke an os-mutating op outside `run`
  Then it mutates its dests without archiving them first
  And its ledger records carry no backup reference

Scenario: an explicit snapshot archives whatever the switch says (todo)
  Given `backup.autoCreate.enabled` is false
  When I invoke `backup create`
  Then the archive is written exactly as with the option left on

Scenario: automatic backup stays on unless turned off (todo)
  Given `backup.autoCreate.enabled` is unset
  When I invoke `run`
  Then the backup stage archives every would-change dest
  And `config show --all` reports `backup.autoCreate.enabled = true (default)`

Scenario: the switch reads from flag, env and config alike (todo)
  When I set `backup.autoCreate.enabled` in the user config or spec file
  Then `--backup-auto-create` overrides it
  And `CHE_BACKUP_AUTO_CREATE` overrides the config layers below it
  And `config show` attributes the value to the layer it came from

<!-- [<] 🤖🤖 -->
