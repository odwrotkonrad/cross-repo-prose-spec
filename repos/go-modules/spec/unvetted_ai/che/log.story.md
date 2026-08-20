# Feature: Che Log

<!-- [>] 🤖🤖 -->

Two log kinds: human log for the CLI, machine log for otel/prometheus. The human
log is readable prose: headings, indentation, multi-line allowed. `CHE_LOG_LEVEL`
selects error (failures only), warn (adds warnings), info (default, what
happened), debug (adds what will and will not happen, and why), trace (adds
details). Discovery reports each profile, its working directory, and its ops with
delta counts. Ops report the mutations they make or would make.

## As an operator

Reads che's output while it runs. Wants to know what happened, not how it is
implemented.

### The CLI log stays prose, never machine format (tested)

I want the CLI to print the human log only, the machine log carrying structured
events to otel and prometheus, structure coming from headings and indentation,
so that reading a run needs no parser.

### One env var dials verbosity, info by default (tested)

I want `CHE_LOG_LEVEL=error|warn|info|debug|trace` to include that level and
every higher-severity one, info applying when unset,
so that detail is one variable away.

### Raising verbosity only adds lines (tested)

I want severity order error > warn > info > debug > trace to hold, each level
adding to the one above and never dropping a severe line,
so that turning up detail never hides a failure.

### Info-level output holding completed facts only (tested)

I want info to report completed facts, no line announcing what is going to
happen and none explaining what is not,
so that the default level is a record, not a plan.

### Debug adding what will and will not happen, with reasons (tested)

I want debug to add what is going to happen and what is not, each with its
reason,
so that an unexpected no-op explains itself.

### Trace detail confined to trace (tested)

I want trace to add detail-level events that never log at info or debug,
so that everyday levels stay readable.

### Severity prefixes that grep-filter (tested)

I want `[error] `, `[warn] `, `[debug] ` and `[trace] ` prefixes with info lines
unprefixed,
so that one grep isolates a severity.

### The run log reading as a document (tested)

I want each profile as a `# Run profile <ref>` heading, each op a `## <op>`
sub-heading beneath it, each mutation a plain indented line, a changeless op a
heading with a no-changes note and nothing beneath, and no repeated profile-name
suffix on nested lines,
so that a long run scans by structure.

### Headings marking where setup ends and execution begins (implemented)

I want `che run` at info to announce the init-remote-sources stage before the
remote lines and the discover-profiles stage before the discovered profiles,
so that setup output is never mistaken for work.

### The spec file driving the run named (implemented)

I want discovery at info to report the che spec path in use,
so that the wrong spec is caught at the top of the output.

### One entry per remote, state and cache location (implemented)

I want one entry per remote at info stating whether it was initialized or
updated and that it landed in cache, the path abbreviated,
so that dependency state reads in one pass.

### Each profile's workdir and op plan, deltas included (implemented)

I want a `## Profile <ref>  (profile workdir: <dir>)` heading one level under
`# discover-profiles`, listing the working directory and the os-mutating
commands in execution order, `run --skip-ops` ops excluded, every declared op listed
zero-delta included as `<op>: <changes> (<n> declared)`,
so that the plan states its size before anything runs.

### Each declared item marked changed or unchanged at debug (todo)

I want debug to add one line per declared item under its op, marked changed or
unchanged,
so that a delta count is traceable to the items behind it.

### A rejected profile logged with its reason (tested)

I want debug to report a rejected profile with the reason and no ops list,
so that an absent profile is explained, not just missing.

### Dry-run output equal to the mutations a real run would make (implemented)

I want `dry-run=delta` to report only changing operations, each predicted
mutation affirmative with a `(dry run)` suffix and never a `will not` line, and
`dry-run=all` to add every settled dest as `will not <action> <dest>: <reason>`
distinguishing already-exists, already-linked, same-content and already-set,
the no-op line carrying only its reason, `dry-run=all` bypassing the zero-delta
profile skip,
so that a dry run is trusted as a preview of the real thing.

### Fresh dests reading differently from replaced ones (implemented)

I want created for a previously absent dest and overwritten for an existing one,
template renders reporting under the render-templates op heading,
so that a destructive write is visible as one.

### A zero-delta op still executing, visibly (tested)

I want an op whose delta is zero to run anyway (idempotent, sweeps included) and
note `(no changes)` on its heading at info,
so that sweeps are not silently skipped.

### Uninstall unwinding newest-first, grouped per profile (implemented)

I want each profile's removals under a `profile <ref>` heading, profiles
unwinding in reverse of application order, each removed dest one indented line,
so that an uninstall reads as the inverse of the run that made it.

### A non-empty dir kept, with a reasoned skip line (implemented)

I want uninstall to leave a dir holding other content, logging a debug
`will not remove <dest>: directory not empty`,
so that unrelated content is never destroyed and the skip is explained.

### A kept dir leaving no removal trace (todo)

I want a dir kept for holding other content to log no `removed <dest>` line,
record no inverse removal in the ledger and surface no raw rmdir stderr,
so that the log and the ledger state only what happened.

## As a config author

Owns che's configuration. Wants to see what is set and where it came from.

### Debug logging only what differs from defaults (tested)

I want debug at command start to report the config options differing from
defaults, never the full config,
so that the interesting configuration is the visible one.

### Config show defaulting to changed options, with sources (implemented)

I want `che config show` and `che config show --delta` to list the options
differing from defaults with their sources, `--delta` being the default mode,
so that inspecting configuration takes no flags.

### Every option listed on demand (tested)

I want `che config show --all` to list every option with its value and source,
changed options first in config order and the rest following in config order,
so that a full audit is one flag away and still reads changed-first.

### Untouched and default-valued options distinguished (tested)

I want an option no source sets to show its default labeled `(unset)`, and an
option a source sets to its default value to be labeled with its source
(`(cliFlag)`) and sort with the changed ones,
so that "nobody set this" and "someone set this to the default" never look the
same.

### A default config printed straight from che (implemented)

I want `che config show --defaults` to print every option at its code default,
ignoring configured values, mutually exclusive with `--delta` and `--all`,
so that the shipped baseline is readable without an empty host.

### A config.yml seeded from any show mode (implemented)

I want `--output=yaml` to print nested YAML in config-file shape
(`packages.binary.checkInPath` -> `packages: {binary: {checkInPath: ...}}`) in
config order, bools and lists keeping their types, flag-only options
(cheWorkingDirectory, skipRunIf, errexit, packages.override) omitted, the output
round-tripping as `$XDG_CONFIG_HOME/che/config.yml`, `--output=text` keeping the
`key = value  (source)` lines,
so that current state becomes a config file without hand-editing.

### Config show output piping clean (implemented)

I want only the per-option lines, no `config delta ...` summary line,
so that the output feeds a pipe unchanged.

<!-- [<] 🤖🤖 -->
