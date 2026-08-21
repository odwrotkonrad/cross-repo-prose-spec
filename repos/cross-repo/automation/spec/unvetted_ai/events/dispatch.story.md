# Feature: Events Dispatched To Handlers

<!-- [>] 🤖🤖 -->

Automation used to receive one message, a producer release, and answer it with
one fan-out: pin iac, then every consumer, each consumer polling a group
variable until it carried the tag. The poll never worked (the variables API
needs Owner, the token is Maintainer) and the fan-out parked for half an hour
before failing.

The ordering the poll enforced is an event iac already knows: its main apply
changed some group variables. So a release is one event answered with one
regen (iac), and iac's apply is a second event answered with the consumers.
Every event arrives as one JSON object in `AUTOMATION_EVENT`, a Ruby
dispatcher picks the handler by `type`, the handler emits the child pipeline.

## As an automation maintainer

Owns the dispatcher, the handlers, the emitted pipeline.

### One handler per event type (todo)

I want `dispatch-event` to parse `AUTOMATION_EVENT`, pick the handler by
`type`, fail on a type it does not know,
so that adding a reaction is adding a handler, and nothing unhandled passes.

### A release regenerates the repo publishing its variable, only (todo)

I want `release.published` to emit one pin regen per repo whose graph `edges`
map the released artifact into a `ci-var/<name>` artifact it produces (iac),
the tfvars key `<NAME>` derived from that artifact, and a release no edge
maps to fail the dispatch,
so that the release reaches the one place that holds its version, nothing
renders ahead of the variable, and no repo or variable name is hardcoded in
automation.

### A changed variable regenerates its consumers (todo)

I want `ci-var.changed` to emit, for every changed `GRP_KO_VAR_<NAME>` that
some `ci-var/<name>` edge publishes, one content regen per consumer of the
edge's source artifact, rendered with `<NAME>` set to the variable's new
value,
so that a consumer renders only once the variable it reads carries the tag,
and the consumer set follows declarations alone.

### Nothing polls a group variable (todo)

I want no regen job to read the group variables API,
so that the fan-out needs no role the token lacks and parks on nothing.

### An empty change is a green no-op (todo)

I want `ci-var.changed` with no variables to emit one no-op job,
so that an apply that moved nothing still reports a green dispatch.

### Regen jobs run small (todo)

I want `dispatch-event` and every emitted regen job tagged
`gke-linux-amd64-small`,
so that a clone-render-MR job does not hold a medium node.

### The dispatcher is unit-tested (todo)

I want event parsing, graph queries and each handler's emitted YAML covered by
minitest against fixtures, run by `make test` and a CI job,
so that a handler change proves itself without a release.

### One Ruby CLI carries every automation command (todo)

I want `aggregate`, `regen`, `sweep`, `dispatch` and `graph` as subcommands of
`bin/automation`, stdlib only, planning pure and tested, IO in runners, the
zsh scripts gone,
so that one language, one entrypoint and one test suite cover what three
shell scripts and a dispatcher did.

<!-- [<] 🤖🤖 -->
