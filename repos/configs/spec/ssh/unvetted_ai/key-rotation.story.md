# Feature: SSH key rotation

<!-- [>] 🤖🤖 -->

`fn-ssh-generate-keys` mints `id_access` and `id_signing`, then calls
`fn-ssh-publish-keys`, which registers both on GitLab under their file names
and appends the signing key to `~/.ssh/allowed_signers`. The signers file is
per-host state, never tracked: retired keys stay so old signatures keep
verifying.

## As a developer

Rotates their own keys on their own machine, never touches the GitLab account
by hand.

### Rotate keys without a manual registration step (implemented)

I want generating a keypair registering it on GitLab in the same command,
so that a rotation never leaves pushes failing on a key the account lacks.

### Keep signing verified locally after a rotation (implemented)

I want the new signing key appended to `allowed_signers` as it is minted,
so that `git log --show-signature` never says `No principal matched` on my own
commits.

### Read old commits as verified after rotating (implemented)

I want retired signing keys left in `allowed_signers`,
so that history signed by a previous key still verifies.

### Re-run the publish safely (implemented)

I want a second run reporting the keys already registered and leaving the
signers file byte-identical,
so that I can run it to confirm state without changing any.

### Rotate on a host that never had these keys (implemented)

I want a missing `allowed_signers` created and an absent public key reported
as an error,
so that a fresh host converges to the same state as an old one.

## As an account owner

Owns the GitLab account the keys authenticate against, cares what credentials
it accumulates.

### Retire the key a rotation replaces (implemented)

I want a stale key under the same title deleted as the new one registers,
so that the account does not collect a dead key per rotation.

### Register each key with the usage it is for (implemented)

I want `id_access` registered as `auth_and_signing` and `id_signing` as
`signing`,
so that GitLab marks my commits verified and my pushes authorized.

<!-- [<] 🤖🤖 -->
