# Feature: Reconcile Declared Keys

<!-- [>] 🤖🤖 -->

`sync`: the planner reads config, state and the clock, emits an ordered action
list, and the runner executes it.

## As a key owner

Declares keys in one config. Runs one command. Reads no state file by hand.

### A declared key that does not exist is created and published (implemented)

I want `sync` to generate any key named in config but absent from state, then
publish it to every platform in its `publishTo`,
so that declaring a key is the whole act of creating one.

### A second sync changes nothing (implemented)

I want a run over an already-reconciled config to emit no actions,
so that `sync` is safe to run on a schedule.

### A key published nowhere new is left alone (implemented)

I want a key already present on every platform in `publishTo` to be skipped,
so that re-publishing never mints duplicate platform entries.

### A dry run writes nothing (implemented)

I want `--dry-run` to print the planned actions and exit before any keygen,
platform call or state write,
so that the plan is inspectable before it costs anything.

## As an operator

Runs `sync` unattended. Reads stderr when something needs attention.

### A key dropped from config is withdrawn (implemented)

I want a key in state but absent from config to be revoked from every platform
holding it,
so that removing a key from config actually retires it.

### A stale state file is announced, not fatal (implemented)

I want a loaded state whose `configfile` differs from the config in use to warn
on stderr and continue,
so that moving a config is visible without blocking the run.

<!-- [<] 🤖🤖 -->
