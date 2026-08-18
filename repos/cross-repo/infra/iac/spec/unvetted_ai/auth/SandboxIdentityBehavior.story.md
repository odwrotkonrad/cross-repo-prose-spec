# Feature: Sandbox identity provisioned by the auth module

<!-- [>] 🤖🤖 -->

## As an AI agent running in a session

Pushes branches and opens MRs from inside the pod. Holds no destructive right,
no op access.

### Push and open MRs without a destructive credential (todo)

I want the `sandbox-rw-nodelete` group access token on `konradodwrot`
(developer: api, read_repository, write_repository),
so that non-protected pushes and MRs succeed while protected-branch pushes and
branch, tag or repository deletion are rejected.

### Every identity secret through one grant (todo)

I want the five sandbox secrets in the `konradodwrot-sandbox-auth` project and
`roles/secretmanager.secretAccessor` held project-wide, with no per-secret IAM
members,
so that every ADC fetch succeeds on that single grant and nothing outside the
auth project is readable.

### Read-only sight of the dev management plane (todo)

I want `roles/viewer` on the `dev` folder under `sandbox`,
so that queries under that folder read and every write is denied.

## As an infra operator

Applies the auth module. Owns the vault, the keys, and what never reaches a
pod.

### A compromised pod yields no 1Password access (todo)

I want terraform to provision no op identity for the sandbox,
so that an inspected pod holds no op token, account, or vault access.

### Key rotation lands in the vault with no manual step (todo)

I want the module to own the SA key and the `sandbox-gcp-sa` item in the
`SandboxProgrammaticAccess` vault,
so that an apply writes fresh key JSON into the `sa_key` field without any `op
item edit`.

### Host keeps its access, sandbox stays credential-minimal (todo)

I want the user to retain vault write access while the module provisions no
github credential,
so that only the SA key crosses into the pod and sandbox github operations run
as anonymous read.

<!-- [<] 🤖🤖 -->
