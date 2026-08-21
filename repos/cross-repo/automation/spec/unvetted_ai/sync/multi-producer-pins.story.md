# Feature: Several prose producers, one propagation path

<!-- [>] 🤖🤖 -->

## As a consumer repo owner

Pins producers' versions and builds against them.

### Three pins, one per prose half and one for misc (implemented)

I want `PROSE_ASSETS_REF`, `PROSE_SPEC_REF`, `MISC_REF` pinned separately,
so that a spec edit never forces a re-render of assets.

### A producer is named by its repo path (implemented)

I want regen to identify a producer by its path under the group and
derive the pin variable and tfvars key from it,
so that a moved producer needs no code change in automation.

### A release triggers automation by the new path (implemented)

I want every producer's release job to send `cross-repo/automation` a
`release.published` event naming `producer`, `artifact`, `tag`,
so that no producer carries a prose-specific variable name.

### No legacy pin survives the split (implemented)

I want `GRP_KO_VAR_PROSE_REF` gone with the split, every consumer moved to
the three pins in the same rollout,
so that nothing reads a variable that no release updates.

<!-- [<] 🤖🤖 -->
