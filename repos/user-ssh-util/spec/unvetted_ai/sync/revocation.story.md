# Feature: Revocation

<!-- [>] 🤖🤖 -->

A superseded grant is revoked once the replacement is proven to work. Effective
platform list per key: `--revoke-platforms`, else per-key `revokePlatforms`,
else top-level, else every platform holding the key.

## As a key owner

Wants a rotated key gone from the platforms, without ever losing access.

### The old key is revoked by default (implemented)

I want rotation to delete the superseded key from every platform holding it,
after the replacement is published and verified,
so that rotating actually retires the old key instead of leaving it valid.

### A key dropped from config is revoked (implemented)

I want a key in state but absent from config to be unpublished everywhere,
so that deleting a key from config actually withdraws it.

### Revocation never destroys a private key (implemented)

I want the superseded keypair moved into `backups/` rather than deleted,
so that a revoked key can be restored or re-published later.

### A revoked key leaves the live ssh directory (implemented)

I want revocation to move the keypair out of `~/.ssh`,
so that a key I withdrew is not still sitting where every ssh client finds it.

### A revoked signing key loses its allowed_signers line (implemented)

I want revocation to drop the key's entry from `allowed_signers`, backing the
file up first,
so that withdrawing a signing key actually withdraws the trust it carried.

### An orphan left published keeps its keypair (implemented)

I want a key reported as an orphan, with nothing revoked, to stay untouched in
`~/.ssh`,
so that opting out of revocation opts out of every part of it.

## As an operator

Decides which platforms this tool may delete keys from, when the default is too
broad.

### A named platform is the only one touched (implemented)

I want `--revoke-platforms=gitlab` to delete the old key from gitlab and leave
it published on github,
so that one platform can be retired at a time.

### A platform kept out is announced (implemented)

I want each platform still holding a superseded key reported on stderr,
so that a deliberately kept grant is never forgotten.

### An empty list opts out of revoking entirely (implemented)

I want `revokePlatforms: []` to leave every grant in place, the orphan reported
rather than deleted,
so that a cautious setup can keep the old behavior.

### The per-key list beats the top-level one (implemented)

I want a key's own `revokePlatforms` to override the top-level list for that key
alone,
so that one key can be stricter or looser than the rest.

### The flag beats both config scopes (implemented)

I want `--revoke-platforms` to override the per-key and top-level lists,
so that a one-off run needs no config edit.

<!-- [<] 🤖🤖 -->
