# Feature: Session auth injection

<!-- [>] 🤖🤖 -->

## As a sandbox session user

Starts and attaches to sessions from the host. Never hand-copies credentials
into a pod.

### One secret crosses the host boundary (todo)

I want `session-create` and `session-attach` carrying only the sandbox SA key
from op into the pod as `GCP_SA_KEY`,
so that no ssh key, gitlab token or op credential is read on the host.

### A missing credential fails the image build (implemented)

I want the config image build exiting non-zero and naming the missing op path
when the SA key is absent,
so that no image is baked half-authenticated.

### A stale image cannot hide a missing credential (todo)

I want `session-create` and `session-attach` exiting non-zero and naming the
missing op path when the SA key is absent and `GCP_SA_KEY` unset, before any
kubectl apply,
so that no session starts half-authenticated.

## As an AI agent running in a session

Pushes, opens MRs, reads secrets from inside the pod. Holds no host credential.

### Full working identity assembled in-pod (implemented)

I want glab resolving the gitlab token from `$GITLAB_TOKEN_SECRET_PATH` in GCP
Secrets Manager via the injected ADC on first use,
so that no gitlab token is read on the host.

### Signing keys fetched in-pod, never copied from the host (todo)

I want the sandbox-runtime profile fetching both ssh keypairs from GCP Secrets
Manager via the injected ADC,
so that a host compromise leaks nothing beyond the one injected key.

<!-- [<] 🤖🤖 -->
