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

<!-- [<] 🤖🤖 -->
