# Feature: Che Discover Operation

<!-- [>] 🤖🤖 -->

`discover-profiles`: print the resolved runtime spec `che run` would execute.

Os-mutating commands: `run`, `backup`, `prune-broken-links`, `make-dirs`,
`make-links`, `make-copies`, `render-templates`, `run-scripts`, `uninstall`
(ledger-driven, no discovery).

## As a config author

Writes che specs, wants the resolved plan before the host changes. Does not
read che's internals.

### A run previewed without touching the host (tested)

I want `discover-profiles` standalone to log the discovered profiles and the
os-mutating operations each would perform,
so that a spec is checked before it runs.

### The plan printed with no log-level tuning (tested)

I want discovery to list profiles with `CHE_LOG_LEVEL` unset, standalone or
under any os-mutating command,
so that the plan is visible by default.

### Discovered profiles readable as headings, ops beneath (tested)

I want each discovered profile logged as a `### Profile <ref>` heading, ops
indented beneath,
so that a long plan scans by profile.

### A directly invoked op still prints the full plan first (tested)

I want an os-mutating command invoked outside `run` to discover first and log
profiles with their operations,
so that skipping the wrapper never costs the preview.

### Opting out of auto-discovery gets a clear ask for --profiles (tested)

I want `options.autoDiscover: false` to disable discovery and error asking for
`--profiles`, forced profiles and sourced refs still running,
so that a disabled default fails with instructions, not silence.

## As a developer

Owns che's run sequence. Cares where discovery sits, not what a spec says.

### Every mutating command works from fresh discovery (tested)

I want discovery to run first for every os-mutating command except `uninstall`
(ledger-driven), its result fixing the profile execution order,
so that no command acts on a stale plan.

### Discovery costs once per run (tested)

I want `run` to discover once, every wrapped command reusing that result,
so that a run pays remote resolution once.

### The runtime spec logs once, at the top (tested)

I want the runtime spec logged once at execution log start,
so that the plan reads as a header, not a repeated interruption.

<!-- [<] 🤖🤖 -->
