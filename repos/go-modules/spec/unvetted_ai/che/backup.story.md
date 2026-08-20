# Feature: Che Backup Operation

<!-- [>] 🤖🤖 -->

`backup` archives every existing op dest that would change (unsettled links,
differing copies, differing renders) into the per-run archive. Subcommands:
`backup create`, `backup restore` (by `--run-id`, `--backup-id`, or
`--timestamp`), `backup ls`.

## As an operator

Runs che against a real host, recovers it when a run goes wrong. Owns the
machine, not che's code.

### One command covers archive, restore and listing (tested)

I want `backup` to carry `create`, `restore` and `ls`, bare `backup` printing
usage for the three,
so that recovery needs no second tool.

### Only what a run would touch gets archived (tested)

I want `backup create` to archive every existing dest an op would change and
skip settled ones,
so that an archive holds the host state actually at risk.

### A restore point picked from a newest-first listing (tested)

I want `backup ls` to list every ledger-recorded backup point under a
`# backups` heading with run id, backup id, timestamp, size and abbreviated
path, newest first,
so that picking a restore point is reading one list.

### A whole run undone with a single run id (tested)

I want `backup restore --run-id <id>` to restore exactly that run's archives
and fail clearly on an unknown id,
so that one bad run reverts as one unit.

### One archive restored without disturbing its run (tested)

I want `backup restore --backup-id <id>` to restore the single archive carrying
that id and fail clearly on an unknown id,
so that a single file recovers without rolling back everything beside it.

### The host rolled back to a chosen moment (tested)

I want `backup restore --timestamp <ts>` to restore each dest to the most
recent backup at or before it, leave dests with no such backup as-is, and fail
clearly when nothing predates the timestamp,
so that recovery targets a point in time, not a run id I have to find.

### Pre-run state recovered, drifted files never clobbered (tested)

I want restore to require exactly one of `--run-id`, `--backup-id`,
`--timestamp`, skip dests drifted from che's last recorded state, report each
restore as `restore <dest> (dry run)` under dry run, and fail clearly on an
unreadable archive,
so that recovery never destroys work done since the run.

### Any archive located from its path alone (tested)

I want every archive at `backups/<profile-slug>/<op>/<ts>-<backup-id>.tar.bz2`
under the state dir, profile ref slugified (`cli/macos` -> `cli-macos`), one
run's archives sharing its timestamp and run id, each carrying a unique 12-char
backup id,
so that a path identifies profile, op and run with no lookup.

### Two log lines say what was backed up and where (tested)

I want a `backup delta <op> (<n> changes)` line always listing the covered file
ops, a `created <size>, <path>` line for the written archive, silence beyond
that when there is nothing to back up, and `create <path> (dry run)` under dry
run,
so that the archive is auditable from the log alone.

### Proof the backup ran even with nothing to archive (tested)

I want a `## backup` heading under the profile heading with the delta line
always beneath it,
so that a silent stage is never mistaken for a skipped one.

## As a developer

Works on che's ops and ledger. Owns the run sequence, not the host it lands on.

### A restore point exists before any op mutates the host (tested)

I want the backup stage to run after init-remote-sources and discover-profiles
and before every other op, archiving every would-change dest into one per-run
archive while automatic backup stays on,
so that no mutation ever precedes its own recovery point.

### One archive per run, not scattered per-op archives (tested)

I want wrapped ops to write no archive of their own,
so that a run reverts as one unit.

### A directly invoked op still backs itself up (tested)

I want an os-mutating op invoked outside `run` to archive its own dests before
mutating, while automatic backup stays on,
so that skipping the wrapper never skips protection.

### Disposable hosts pay nothing for a recovery point they will never use (tested)

I want `backup.autoCreate.enabled: false` (`--backup-auto-create=false`,
`CHE_BACKUP_AUTO_CREATE`) to silence both automatic paths, the `run` stage and a
direct op's own archiving, default true,
so that a throwaway CI container skips work whose only product is thrown away
with it.

### An explicit snapshot ignores the automatic switch (tested)

I want `backup create` to archive even with `backup.autoCreate.enabled: false`,
so that turning off automatic protection never disarms the command whose whole
job is protection.

### Every ledger record points at the run's actual archive (implemented)

I want a wrapped op's mutation record to reference the run's backup archive,
so that a record always resolves to the archive that can undo it.

<!-- [<] 🤖🤖 -->
