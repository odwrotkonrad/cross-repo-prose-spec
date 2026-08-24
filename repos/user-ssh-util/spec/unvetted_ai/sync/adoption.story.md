# Feature: Adopt An Existing Key

<!-- [>] 🤖🤖 -->

A keypair the user made by hand is taken under management, never regenerated
over. State records what is already there, on disk and on each platform.

## As a key owner

Has keys that predate the tool, and wants them managed without losing them.

### A keypair already on disk is adopted (implemented)

I want a declared key whose keypair exists in `~/.ssh` but is absent from state
to be adopted rather than created,
so that the material I already published elsewhere survives.

### Adoption preserves the original material (implemented)

I want the public key after adoption to be byte-for-byte the one I generated,
so that every grant I made by hand keeps working.

### An adopted signing key enters allowed_signers (implemented)

I want adoption to register a signing key the same way creation does,
so that a later rotation finds the entry it expects to swap.

### The first-created time comes from the file (implemented)

I want `firstCreatedAt` taken from the keypair's mtime,
so that the record reflects when the key really appeared, not when I adopted it.

## As an operator

Rebuilds state, and must not double-publish in the process.

### An already-published key is matched, not duplicated (implemented)

I want a key whose material is already on a platform to be recorded under the
title that platform gave it,
so that a rebuilt state file never leaves a second live grant behind.

### Matching ignores the platform's own comment (implemented)

I want the match to compare algorithm and body only,
so that GitLab rewriting the trailing comment cannot hide my own key from me.

### A missing keypair is still created (implemented)

I want a declared key with nothing on disk to be created as before,
so that adoption never masks a key that genuinely does not exist yet.

<!-- [<] 🤖🤖 -->
