# Feature: Command Predicate In runIf

<!-- [>] 🤖🤖 -->

`runIf` decides whether a profile runs. Its sources answer static questions:
`builtin:isOs`, `builtin:isVirt`, `env:<NAME>`. Some gates are neither static nor
an environment variable: whether a tool is authenticated, whether a daemon
answers. Testing those through `env:` picks one mechanism and mistakes it for the
condition, so a profile skips whenever auth arrives by another route.

`cmd:<argv>` closes that gap. It runs the command and passes on exit code 0.

## As a config author

Writes `che.yml` profiles. Gates them on the machine's real state, not on a proxy
for it.

### Gate a profile on a real capability, not a stand-in for one (todo)

I want `cmd:<argv>` as a `runIf` source, passing when the command exits 0 and
failing on any other code,
so that a profile's gate asks the question it means instead of guessing at one
mechanism that answers it.

### A gate that reads state can change its mind within one run (todo)

I want a `cmd:` predicate evaluated on every use, never cached the way the
immutable `builtin:` sources are,
so that a gate over mutable state stays truthful when that state moves.

### A probe stays out of the output (todo)

I want the command's stdout and stderr discarded, the exit code the whole
contract,
so that a gate never prints into a run it only meant to decide.

### Compose a command gate like any other source (todo)

I want `cmd:` usable bare or as `cmd:<argv> == true`, ANDed with the other
predicates in the list,
so that a new source needs no new grammar.

### A gate runs a binary, not a shell line (todo)

I want the argv split on whitespace and executed directly, no shell, no quote or
operator parsing,
so that a predicate cannot smuggle a pipeline or a redirect into a gate, and a
command needing shell syntax is written as an explicit interpreter invocation.

### A malformed gate names its own fault (todo)

I want an empty `cmd:` rejected with an error, and the unknown-source error
listing `cmd:<argv>` beside the sources it already names,
so that a typo is legible without reading che's source.

## As a spec reader

Reads `che.schema.json` and the CLI docs to learn what a field accepts. Reads no
Go.

### The schema admits the source it documents (todo)

I want `runIf`'s schema description naming `cmd:<argv>` alongside `builtin:*` and
`env:*`, generated from the source, never hand-edited,
so that validation and documentation agree on what a predicate may be.

<!-- [<] 🤖🤖 -->
