# Feature: Several prose producers, one propagation path

<!-- [>] 🤖🤖 -->

## As a consumer repo owner

Pins producers' versions and builds against them.

### Three pins, one per prose half and one for misc (todo)

I want `PROSE_ASSETS_REF`, `PROSE_SPEC_REF`, `MISC_REF` pinned separately,
so that a spec edit never forces a re-render of assets.

### A producer is named by its repo path (todo)

I want regen to identify a producer by its path under the group and
derive the pin variable and tfvars key from it,
so that a moved producer needs no code change in automation.

### A release triggers automation by the new path (todo)

I want every producer's release job to call `cross-repo/automation`
with `RELEASE_TAG`, `PRODUCER`, `PRODUCER_ARTIFACT`,
so that no producer carries a prose-specific variable name.

<!-- [<] 🤖🤖 -->
