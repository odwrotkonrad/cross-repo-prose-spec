# Feature: Che Backup Operation

<!-- [>] 🤖🤖 -->

Scenario: a user picks a restore point from a newest-first listing (tested)
  When I invoke `backup ls`
  Then every ledger-recorded backup point lists under a `# backups` heading, newest first
  And each entry shows run id, backup id, timestamp, size, abbreviated path
  And no backup points lists nothing

Scenario: a user undoes one whole run with a single run id (tested)
  When I invoke `backup restore --run-id <id>`
  Then exactly that run's archives restore
  And an unknown run id fails with a clear error

Scenario: a user restores one archive without touching the rest of its run (tested)
  When I invoke `backup restore --backup-id <id>`
  Then only the archive whose filename carries that id restores
  And an unknown backup id fails with a clear error

Scenario: a user rolls the host back to a chosen moment (tested)
  When I invoke `backup restore --timestamp <ts>`
  Then each dest restores to its newest backup at or before the timestamp
  And a dest with no such backup stays as-is
  And a timestamp predating every backup fails with a clear error

Scenario: a user recovers pre-run state, drifted files never clobbered (tested)
  When I invoke `backup restore` with a selector matching a known archive
  Then every entry restores onto its recorded dest
  And anything but exactly one of `--run-id`, `--backup-id`, `--timestamp` fails with a clear error
  And a dest drifted from che's last recorded state is skipped
  And dry run prints `restore <dest> (dry run)` per entry and writes nothing
  And an unreadable archive fails with a clear error

Scenario: a user snapshots on demand, settled dests skipped (tested)
  When I invoke `backup create` standalone
  Then every existing dest an op would change lands in the per-run archive
  And settled dests are not archived
  And nothing to change archives nothing

Scenario: a disposable host runs with no archive written (tested)
  Given `backup.autoCreate.enabled` is false
  When I invoke `run`
  Then no archive lands under the state dir
  And every op still mutates

Scenario: a skipped backup stage says why (todo)
  Given `backup.autoCreate.enabled` is false
  When I invoke `run`
  Then a debug line names the option as the skip reason

Scenario: a directly invoked op honours the same switch (implemented)
  Given `backup.autoCreate.enabled` is false
  When I invoke an os-mutating op outside `run`
  Then it mutates its dests without archiving first
  And its ledger records carry no backup reference

Scenario: an explicit snapshot archives whatever the switch says (tested)
  Given `backup.autoCreate.enabled` is false
  When I invoke `backup create`
  Then the archive is written as if the option were on

Scenario: automatic backup stays on unless turned off (implemented)
  Given `backup.autoCreate.enabled` is unset
  When I invoke `run`
  Then the backup stage archives every would-change dest
  And `config show --all` reports `backup.autoCreate.enabled = true (default)`

Scenario: the switch reads from flag, env and config alike (implemented)
  When I set `backup.autoCreate.enabled` in the user config or spec file
  Then `--backup-auto-create` overrides it
  And `CHE_BACKUP_AUTO_CREATE` overrides the config layers below it
  And `config show` names the layer the value came from

<!-- [<] 🤖🤖 -->
