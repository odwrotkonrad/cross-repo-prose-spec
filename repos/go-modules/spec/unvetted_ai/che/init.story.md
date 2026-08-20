# Feature: Che Init Operation

<!-- [>] 🤖🤖 -->

`init-remote-sources`: prefetch remote spec sources into the run cache.

## As an operator

Runs che where the network is slow, rate-limited or absent. Owns the host, not
the specs.

### Every remote source ready up front, nested refs included (tested)

I want every remote spec source reachable from the root spec cloned or pulled
into the cache, top-level `include.sources` and every profile's sourced
`include.profiles` refs covered recursively,
so that a run never stalls midway on an unfetched source.

### Guarded sources cached too, so offline stays safe (tested)

I want a `runIf`-guarded source fetched without evaluating the condition,
discovery deciding later what runs,
so that a condition flipping offline still finds its source.

### Each remote fetched at most once per run (tested)

I want init to run before discovery and discovery to reuse init's checkouts,
so that one run pays one fetch per source.

### A cached checkout stands in for an unreachable remote (tested)

I want a failed update with a cached checkout to log
`fetch failed, using cached checkout <path>` and proceed on the cache,
so that a flaky remote does not stop a host from converging.

### An unfetchable, uncached remote stops the run (tested)

I want init to error and abort when a source fails to fetch with no cached
checkout,
so that che never runs against a spec it could not load.

### Fully offline operation with skipRemoteRefs (tested)

I want `skipRemoteRefs` to attempt no fetch,
so that an air-gapped host runs without network timeouts.

### Every checkout under one predictable cache dir (tested)

I want each clone at `<cache-home>/che/remote-sources/<slug>`,
so that inspecting or clearing the cache needs no search.

## As an agent

Reads che's output to diagnose a run. No host access beyond the log.

### Each remote's fate in one line: cloned, updated, or up to date (tested)

I want one info line per source, `cloned`, `updated` or `up to date remote
<git-url> into <path>`, the cache path abbreviating home to `~`,
so that every dependency's state reads off one pass.

### Each remote dependency tied to its profile (tested)

I want a trace line `detected remote ref profile <profile>: <dependency>`,
so that a fetch is attributable to the profile that asked for it.

<!-- [<] 🤖🤖 -->
