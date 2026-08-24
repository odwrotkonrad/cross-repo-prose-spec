# Feature: Rotation

<!-- [>] 🤖🤖 -->

A key past its period is replaced: generate, publish, verify, revoke, archive,
install, restart the agent.

## As a key owner

Wants keys replaced on a period without ever losing access to a platform.

### A key past its period rotates (implemented)

I want a rotation rule of `period: 1 month` to make `sync` replace any key whose
`lastRotatedAt` is older than that,
so that rotation happens without me tracking dates.

### A key with no rotation rule never rotates (implemented)

I want an absent `period` to disable rotation for that type,
so that a long-lived key stays put.

### The most specific rotation rule wins (implemented)

I want a `scope: <keyname>` rule to beat a `scope: global` rule of the same
type,
so that one key can rotate on its own schedule.

### The new key works before the old one goes (implemented)

I want the replacement published and verified against each platform over SSH
before anything is revoked,
so that a failed publish leaves the old key untouched and me still logged in.

### Verification tests the replacement and nothing else (implemented)

I want the SSH check to ignore my `~/.ssh/config`, so a `Host *` `IdentityFile`
cannot answer for the key under test,
so that a replacement which cannot actually log in fails the check instead of
passing on another key's credentials.

### A signing key is verified by signing (implemented)

I want a signing key proven by signing and verifying a payload rather than by
SSH login, which GitHub grants signing keys by design,
so that rotation tests the capability the key is actually for.

### The old private key survives rotation (implemented)

I want the superseded keypair moved under `backups/<name>/<timestamp>/` and
recorded in state as `archived`,
so that a rotated key can still be re-published for testing.

### A rotated signing key keeps allowed_signers in step (implemented)

I want `~/.ssh/allowed_signers` rewritten with the old public key dropped and
the new one added, the previous file backed up beside it,
so that signature verification never breaks on rotation.

### Rotation refreshes known_hosts (implemented)

I want `known_hosts` backed up and re-scanned for the platform hosts,
so that a rotated host key never blocks the next connection.

### An interrupted rotation leaves a truthful state (implemented)

I want state written atomically after each mutating step,
so that a crash mid-rotation is readable and recoverable, never a half-truth.

<!-- [<] 🤖🤖 -->
