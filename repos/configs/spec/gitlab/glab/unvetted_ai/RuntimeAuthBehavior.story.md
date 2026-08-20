# Feature: Runtime gitlab/github auth resolution

<!-- [>] 🤖🤖 -->

## As a session user

Runs one shell config on the host and in a sandbox, never adjusts credentials
per context.

### The token resolves from the right backend everywhere (implemented)

I want `GITLAB_TOKEN_SECRET_PATH` toggled by `fn-is-virt`: virt shells read
`gcp://konradodwrot-sandbox-auth/sandbox-gitlab-group-token` through the
injected ADC, host shells read `op://ProgrammaticAccess/gitlab/access_token`
through op, every consumer (fn-auth-glab, render-tpl) context-agnostic,
so that one config works unchanged in a pod, a macos-vm and on the host.

## As a repo owner

Grants a sandbox exactly what it needs, nothing it could leak.

### Sandbox github access carries nothing to steal (implemented)

I want github clones and api reads unauthenticated in the pod,
so that no github credential exists in the sandbox to lose.

### Anonymous github access is observable from inside the pod (todo)

I want `gh api /rate_limit` in the pod reporting an anonymous limit,
so that the missing github credential is confirmed, not assumed.

<!-- [<] 🤖🤖 -->
