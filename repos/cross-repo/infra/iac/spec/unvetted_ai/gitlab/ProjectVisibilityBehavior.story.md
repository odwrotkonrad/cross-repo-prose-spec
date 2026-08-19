# Feature: Project visibility

<!-- [>] 🤖🤖 -->

## As an infra operator

Applies terraform for the project tree. Owns the tfvars, not the GitLab UI.

### Visibility is a tfvars edit (implemented)

I want each project's `visibility` to be one tfvars value, defaulting public,
so that making a repo private is a single-line edit, never a UI click.

### The mirror never outlives the flip (implemented)

I want the same value to drive the GitLab project and its GitHub mirror,
so that a private repo is never publicly readable on the mirror.

### Notes carries context privately (todo)

I want the notes project private,
so that cross-session context can be written without it being world-readable.

<!-- [<] 🤖🤖 -->
