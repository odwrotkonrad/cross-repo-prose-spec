# CI Variables Convention

<!-- [>] 🤖🤖 -->

Every CI/CD variable GitLab injects carries a prefix naming the scope that
defines it:

- `GRP_VAR_`: defined on the `konradodwrot` group, readable by every repo under
  it.
- `REPO_VAR_`: defined on one project. The repo is not named: the variable is
  only visible inside that repo, so naming it would restate the scope.

The prefix answers, at the point of use, where a value comes from and where to
go to change it. An unprefixed name in a pipeline is a value the pipeline
itself defines.

All of them are declared in `infra/iac`, never clicked into the UI: group
variables in `tf/modules/gitlab/ci-toggles.tf`, project variables beside the
resource that owns them.

## In The Dependency Graph

A CI variable crosses repo boundaries, so it is an artifact like any other.
`infra/iac` declares each one downstream as `ci-var/<name>`, type `ci-variable`,
and every repo reading it declares `infra/iac/ci-var/<name>` upstream:

```yaml
# infra/iac/.repo/cross-repo-interface.yml
downstream:
  - {name: ci-var/artifact-registry, type: ci-variable}

# a consumer's .repo/cross-repo-interface.yml
upstream:
  - infra/iac/ci-var/artifact-registry
```

The value of declaring it is the question it answers without grep: who reads
this, and what breaks if it changes. Control's aggregation enforces the pair,
so an upstream naming a variable nobody produces fails the build rather than
rotting.

Name the artifact for the value, not the variable: `ci-var/artifact-registry`
covers `GRP_VAR_ARTIFACT_REGISTRY` and its two proxy variables, which are
produced and consumed as one thing. One artifact per variable that can move
independently, not per GitLab key.

A remapped bare name is not a second artifact. It is derived inside one repo's
pipeline and crosses no boundary.

## Remapping

A prefixed name is for our own pipelines. Tools that read the environment
expect their own names and cannot be told otherwise: `glab` reads
`GITLAB_TOKEN`, the GCP SDKs read `GOOGLE_APPLICATION_CREDENTIALS`, Terraform
reads `TF_VAR_*`, che reads `CHE_PACKAGES_REF`.

Such a value exists as two variables, and the distinction is what each one is
for:

- the **prefixed** one, defined in `infra/iac` and injected by GitLab. It is
  the value's home, and the only one anything writes.
- the **unprefixed** one, defined in the pipeline as an assignment from the
  prefixed one. It exists solely because a tool demands that spelling.

```yaml
variables:
  GITLAB_TOKEN: $REPO_VAR_GITLAB_TOKEN
  CHE_PACKAGES_REF: $GRP_VAR_CHE_PACKAGES_REF
  TF_VAR_github_token: $REPO_VAR_GITHUB_TOKEN
```

One line, at the boundary, as close to the job that needs it as possible. The
tool sees the name it requires, the scope that supplied the value is visible at
the point it enters, and nothing further in is renamed for a tool's
convenience.

How close depends on how far the bare name is allowed to reach. A top-level
`variables:` block hands it to every job in the repo, which is right for a
value the whole pipeline wants and wrong for one that would change how a test
behaves. A suite that asserts a tool's default behaviour must not inherit a
variable overriding that default, or it proves the feature against itself. When
that risk exists, the assignment belongs in the jobs that want it, never at the
top. `GRP_VAR_CHE_BACKUP_AUTO_CREATE` is group-scoped for exactly this reason:
one place sets it, each repo decides which of its jobs sees it as
`CHE_BACKUP_AUTO_CREATE`.

Never define the unprefixed name in GitLab. Two GitLab-defined variables
holding one value drift the moment somebody edits the wrong one, and neither
records which is authoritative. The assignment is the whole point: it is
derivation, in a file under review, not a second source of truth.

Read the prefixed name everywhere the tool is not the reader. A script we own
that wants the value reads `$GRP_VAR_...`; only the tool's own lookup gets the
bare name.

## Naming

After the prefix, the name says what the value is, not who reads it:
`GRP_VAR_ARTIFACT_REGISTRY`, not `GRP_VAR_DOCKER_LOGIN_TARGET`. A value used by
three tools has one name, and each remap line names the tool.

Values that are versions end in `_REF`, matching the pins already spelled that
way.

## What Is Not A CI Variable

A value that is neither secret nor environment-specific belongs in the file
that uses it, not in GitLab. A CI variable is for what cannot be committed (a
token) or what one place must own for everyone (a registry host, a pinned
version). Everything else is configuration, and configuration is reviewed in a
merge request.

## Example

Runnable version in `example/`: a `.gitlab-ci.yml` remapping group variables at
the boundary, and the Terraform declaring them.

<!-- [<] 🤖🤖 -->
