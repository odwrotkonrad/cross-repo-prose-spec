# Feature: CI job token allowlists

<!-- [>] 🤖🤖 -->

## As a CI maintainer

Wires cross-project triggers. Does not edit instance-level settings.

### Downstream triggers fire instead of failing (implemented)

I want prose in automation's job token allowlist under instance-enforced
inbound scope,
so that a prose tag pipeline creates the downstream pipeline instead of
returning downstream_pipeline_creation_failed.

## As an infra operator

Applies terraform for the project tree. Owns the tfvars, not the GitLab UI.

### Access changes are a tfvars edit (implemented)

I want each project's `job_token_allowlist` to hold sibling project keys,
so that permitting another project's token changes that entry, never a
resource definition.

### Terraform never fights the instance (implemented)

I want the module to add one allowlist entry and never write the
scope-enabled flag,
so that granting access does not collide with gitlab.com forbidding
per-project scope disabling.

### Grants stay one-directional (implemented)

I want an entry to name exactly one accessed project and one permitted
project,
so that letting prose reach automation grants automation nothing back, and no
third project anything.

<!-- [<] 🤖🤖 -->
