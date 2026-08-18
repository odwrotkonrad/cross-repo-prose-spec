# Feature: SSH key rotation

<!-- [>] 🤖🤖 -->

`fn-ssh-generate-keys` mints `id_access` and `id_signing`, then calls
`fn-ssh-publish-keys`, which registers both on GitLab under their file names and
appends the signing key to `~/.ssh/allowed_signers`. The signers file is
per-host state, never tracked: retired keys stay listed so the commits they
signed keep verifying.

## As a developer

Rotates their own keys on their own machine. Does not administer the GitLab
account by hand.

### Rotate keys without a manual registration step (implemented)

I want generating a keypair to register it on GitLab in the same command,
so that a rotation never leaves pushes failing on a key the account does not
hold.

### Keep signing verified locally after a rotation (implemented)

I want the new signing key appended to `allowed_signers` as it is minted,
so that `git log --show-signature` never reports `No principal matched` on my
own commits.

### Read old commits as verified after rotating (implemented)

I want retired signing keys left in `allowed_signers`,
so that history signed by a previous key still verifies.

### Re-run the publish safely (implemented)

I want a second run to report the keys as already registered and leave the
signers file byte-identical,
so that I can run it to confirm state without changing any.

### Rotate on a host that never had these keys (implemented)

I want a missing `allowed_signers` created and an absent public key reported as
an error,
so that a fresh host converges to the same state as an old one.

## As an account owner

Owns the GitLab account the keys authenticate against. Cares what credentials
it accumulates.

### Retire the key a rotation replaces (implemented)

I want a stale key held under the same title deleted as the new one registers,
so that the account does not collect a dead key per rotation.

### Register each key with the usage it is for (implemented)

I want `id_access` registered as `auth_and_signing` and `id_signing` as
`signing`,
so that GitLab marks my commits verified and my pushes authorized.

<!-- [<] 🤖🤖 -->
