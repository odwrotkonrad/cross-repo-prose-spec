# Feature: Default-deny egress

<!--[>] 🤖🤖 -->

## As a security owner

Owns the whitelist. Does not decide what a session tries to reach.

### One component decides what leaves the cluster (tested)

I want cilium installed as the only CNI and the only enforcer of network policy,
so that no unmanaged path out exists to reason about.

### An unlisted destination is unreachable by name or by ip (implemented)

I want an unwhitelisted domain refused at resolution and any off-cluster address
denied for a pod covered by no rule,
so that skipping DNS buys nothing.

### A rule grants exactly what it names (implemented)

I want a whitelisted domain reachable only on the ports and protocols the rule
names,
so that admitting a host does not admit everything it listens on.

## As a sandbox operator

Diagnoses blocked traffic. Does not author policy.

### A whitelisted destination works first try (implemented)

I want an admitted domain, port and protocol resolving and connecting,
so that a granted rule needs no further setup.

### A missing rule is diagnosable in seconds (implemented)

I want cilium's policy verdicts naming the session, destination and port of a
denied attempt,
so that the fix is a rule, not an investigation.

<!--[<] 🤖🤖 -->
