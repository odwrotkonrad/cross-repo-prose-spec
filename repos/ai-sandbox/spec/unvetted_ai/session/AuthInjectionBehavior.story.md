# Feature: Session auth injection

<!-- [>] 🤖🤖 -->

## As a sandbox session user

Starts and attaches to sessions from the host. Never hand-copies credentials
into a pod.

### One secret crosses the host boundary (todo)

I want `session-create` and `session-attach` to carry only the sandbox SA key
from op into the pod as `GCP_SA_KEY`,
so that no ssh key, gitlab token, or op credential is read on the host.

### A missing credential fails before the pod is touched (todo)

I want the command to exit non-zero naming the missing op path when the SA key
is absent and `GCP_SA_KEY` is unset,
so that no session ever starts half-authenticated.

## As an AI agent running in a session

Pushes, opens MRs, reads secrets from inside the pod. Holds no host credential.

### Full working identity assembled in-pod (todo)

I want the sandbox-runtime profile to fetch the gitlab token and both ssh
keypairs from GCP Secrets Manager via the injected ADC, with glab resolving the
token from `$GITLAB_TOKEN_SECRET_PATH` on first use,
so that a host compromise leaks nothing beyond the one injected key.

<!-- [<] 🤖🤖 -->
