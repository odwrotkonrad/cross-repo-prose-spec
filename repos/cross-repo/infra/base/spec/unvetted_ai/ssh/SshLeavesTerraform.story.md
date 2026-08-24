# Feature: SSH keys leave terraform without being rotated

<!-- [>] 🤖🤖 -->

SSH keys are not created by any infra repo. Today terraform holds eleven
resources it should not: two `tls_private_key`, two `gitlab_user_sshkey`, and
eight Secret Manager secrets and versions carrying copies of the private
material.

The keys themselves are not rotated. They keep working in GitLab and GitHub
exactly as they do now. What changes is that terraform stops describing them:
the four key resources are forgotten with `destroy = false`, and only the
Secret Manager copies are deleted, because a copy of a private key in a place
nothing needs to read is the part worth removing.

One consumer does read those copies. The sandbox pod fetches
`sandbox-ssh-private-key` from Secret Manager at startup, so deleting the
secrets takes its git access away. That is why this step is gated: `ai-sandbox`
gets another delivery path first, and only then does the secret get deleted.

The cost is accepted and recorded: once forgotten, nothing re-creates these
keys if they are deleted by hand.

## As the infra operator

Takes SSH out of terraform without interrupting anything using it.

### Forget the keys instead of destroying them (todo)

I want both `tls_private_key` and both `gitlab_user_sshkey` dropped with
`removed { lifecycle { destroy = false } }`,
so that terraform stops managing them while every key stays live and every
fingerprint stays the same.

### Delete only the copies, never the originals (todo)

I want the eight `google_secret_manager_secret` and version resources deleted
outright,
so that private key material stops sitting in a store that no longer needs to
hold it.

### Gate the deletion on the sandbox having another path (todo)

I want the secret deletion sequenced after `ai-sandbox` can obtain its private
key without Secret Manager,
so that the pod does not lose git access the moment the secret disappears.

### Prove the keys survived (todo)

I want `glab api user/keys` to still list both keys with unchanged
fingerprints, and `gcloud secrets list` to show no `sandbox-ssh-*`, after the
step,
so that "forgotten, not destroyed" is verified rather than assumed.

### Record that nothing re-creates these keys (todo)

I want the deferred rotation and the now-unmanaged keys documented,
so that the next person to delete one by hand knows no apply brings it back.

<!-- [<] 🤖🤖 -->
