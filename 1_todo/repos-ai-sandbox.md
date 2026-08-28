
## Session Setup

- ai sandbox repo MUST define session setup
- ai sandbox session setup MUST include injecting a unique GCP service account into a session pod


## IAM Setup - Providing credentials to sandbox session

- host during session creation MUST provide exactly one credential to the session - a GCP service account with a policy binding allowing for reading secrets
- host MUST generate credentials for a session and create GCP secrets a session will read
- mechanism or script used for generating credentials MUST live in this repo
- sandbox session MUST fetch credentials from GCP and bootstrap access, using a script that lives in this repo
- script MUST generate a credential for each platform, and output only the credential
- a wrapper script MUST invoke auth scripts to assemble terraform input variables
- a terraform module MUST be invoked per group of variables (session variables) using terragrunt
- a terraform module MUST create and manage gcp secrets containing credentials for a session
- a terraform state MUST be stored in a remote GCP bucket
- terraform MUST be applied using the user GCP identity on a host, never in CI
- every secret MUST be scoped to one service account (a session principal) provided as a variable, using secret IAM policy
- ai sandbox repo MUST define auth setup for a session
- auth setup MUST include 2 parts: host steps, and session steps
- auth setup host steps MUST mint credentials using ID definitions from infra base repo in iam/ai-sandbox
- auth setup session steps MUST consume credentials using GCP service account ID and GCP secrets manager
- auth setup session steps MUST include connection verification using IDs it consumes
- all session credentials apart from the GCP service account are published to GCP secrets manager

### SSH
- host that hosts the sandbox cluster MUST generate two ssh keys per sandbox session
