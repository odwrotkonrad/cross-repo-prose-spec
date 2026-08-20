# Feature: Runtime gitlab/github auth resolution

<!-- [>] 🤖🤖 -->

## As a session user

Runs the same shell config on a host and in a sandbox, does not adjust
credentials per context.

### The token resolves from the right backend everywhere (implemented)

I want `GITLAB_TOKEN_SECRET_PATH` toggled by `fn-is-virt`, a virt shell reading
`gcp://konradodwrot-sandbox-auth/sandbox-gitlab-group-token` through the
injected ADC and a host shell reading
`op://ProgrammaticAccess/gitlab/access_token` through op, every consumer
(fn-auth-glab, render-tpl) staying context-agnostic,
so that one config works in a pod, a macos-vm and on the host unchanged.

## As a repo owner

Grants a sandbox exactly what it needs, no credential it could leak.

### Sandbox github access carries nothing to steal (implemented)

I want github clones and api reads running unauthenticated in the pod,
so that no github credential exists in the sandbox to lose.

### Anonymous github access is observable from inside the pod (todo)

I want `gh api /rate_limit` in the pod reporting an anonymous limit,
so that the absence of a github credential is confirmed, not assumed.

<!-- [<] 🤖🤖 -->
