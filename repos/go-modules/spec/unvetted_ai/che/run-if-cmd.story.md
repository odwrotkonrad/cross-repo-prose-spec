# Feature: Command Predicate In runIf

<!-- [>] 🤖🤖 -->

`runIf` decides whether a profile runs. Its sources answer static questions:
`builtin:isOs`, `builtin:isVirt`, `env:<NAME>`. Some gates are neither: is a
tool authenticated, does a daemon answer. Testing those through `env:` mistakes
one mechanism for the condition, so a profile skips whenever auth arrives
another way.

`cmd:<argv>` runs the command and passes on exit 0.

## As a config author

Writes `che.yml` profiles. Gates them on real machine state, not a proxy for it.

### Gate a profile on a real capability, not a stand-in for one (tested)

I want `cmd:<argv>` as a `runIf` source, passing on exit 0, failing otherwise,
so that a gate asks the question it means.

### A gate that reads state can change its mind within one run (tested)

I want `cmd:` evaluated on every use, never cached like the immutable
`builtin:` sources,
so that a gate over mutable state stays truthful.

### A probe stays out of the output (implemented)

I want stdout and stderr discarded, the exit code the whole contract,
so that a gate never prints into the run it decides.

### Compose a command gate like any other source (tested)

I want `cmd:` usable bare or as `cmd:<argv> == true`, ANDed with the other
predicates,
so that a new source needs no new grammar.

### A gate runs a binary, not a shell line (implemented)

I want the argv split on whitespace and exec'd directly, no shell, no quote or
operator parsing,
so that a predicate cannot smuggle in a pipeline or redirect, and shell syntax
needs an explicit interpreter.

### A malformed gate names its own fault (tested)

I want an empty `cmd:` rejected, and the unknown-source error listing
`cmd:<argv>` beside the other sources,
so that a typo is legible without reading che's source.

## As a spec reader

Learns what a field accepts from `che.schema.json` and the CLI docs. Reads no
Go.

### The schema admits the source it documents (implemented)

I want `runIf`'s schema description naming `cmd:<argv>` beside `builtin:*` and
`env:*`, generated from source, never hand-edited,
so that validation and docs agree on what a predicate may be.

<!-- [<] 🤖🤖 -->
