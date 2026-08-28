# Infrastructure

# Platform Rules

## Gitlab

- main pipeline privileged identities MUST be created using GitLab protected masked variables on a group level
- repo main pipeline privileged identities MAY be created using GitLab protected masked variables on a group level, targeting a repo using its mnemonic in the variable name
- only permissions granted MUST be specified in the spec
- repo unprotected branch pipelines MUST NOT have access to privileged credentials, allowing mutations of repo contents from MR level

# Principals

## AI Sandbox

- each session MUST get a unique, revocable credential on each platform

### GCP

- each session MUST get its own unique principal (a service account)
- each session MUST be able to fetch secrets scoped for this session
- one session MUST NOT be able to fetch secrets created for another session
- each session principal MUST NOT have permissions other than its role permissions
- each session principal MUST be granted a role
- role definition with session permissions MUST be fetched from another repo whose purpose is to control IAM definitions

### SSH
- each session MUST get its own two unique ssh key pairs
- ssh keys a session uses MUST be published to gitlab, and to github
- both ssh keys MUST use a variant of the owner email (email@gmail.com -> email+<sessionname>@gmail.com)
- session MUST contain exactly 2 active ssh keys, one for signing and one for authenticated access
- session MUST be able to sign commits using the provided signing key
- session MUST be able to authenticate and access gitlab and github repositories via ssh
- session MUST be able to publish commits to unprotected branches on gitlab and github

### GitLab
- session MUST be authenticated to gitlab via a unique instance fine grained PAT
- session MUST be able to create merge requests in konradodwrot group
- session MUST be able to read all gitlab public repositories
- session MUST be able to use ssh to connect to gitlab
- session MUST be able to read pipeline job logs
- session MUST be able to read pipeline status information
- session MUST be able to create and repeat MR pipelines
- session MUST be able to merge approved MRs
- session MUST NOT be able to merge unapproved MRs
- session MUST NOT be able to merge MRs whose MR checks failed
- session MUST be able to merge MRs whose MR checks passed
- session MUST NOT be able to read group variables (used for providing credentials)
- session MUST be able to read repo project variables (not used for providing credentials)

### GitHub

- session MUST be able to read all public github repositories
- session MUST NOT be provided with a GitHub token <!-- I'm using GitLab to store my repos -->

### Claude

<!-- claude code subscription auth is limited, it's troublesome to get 1 cred per session -->
- session MUST use a shared long lived oauth token prepared with `claude setup-token`
