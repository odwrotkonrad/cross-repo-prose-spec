# CI Variables Convention

<!-- [>] 🤖🤖 -->

Every CI/CD variable GitLab injects carries a prefix naming the scope that
defines it:

- `GRP_<MNEMONIC>_VAR_`: defined on a group, readable by every repo under it.
  The mnemonic names the group, so a reader knows which group without
  opening GitLab.
- `REPO_VAR_`: defined on one project. The repo is not named: the variable is
  only visible inside that repo, so naming it would restate the scope.

Group mnemonics:

| group | mnemonic | prefix |
|---|---|---|
| `konradodwrot` | `KO` | `GRP_KO_VAR_` |

A subgroup that defines its first variable adds a row here, in the same
merge request.

The prefix answers, at the point of use, where a value comes from and where to
go to change it. An unprefixed name in a pipeline is a value the pipeline
itself defines.

All of them are declared in `infra/iac`, never clicked into the UI: group
variables in `tf/modules/gitlab/ci-toggles.tf`, project variables beside the
resource that owns them. A key present in GitLab and absent from `infra/iac`
is drift: import it or delete it.

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
covers `GRP_KO_VAR_ARTIFACT_REGISTRY` and its two proxy variables, which are
produced and consumed as one thing. One artifact per variable that can move
independently, not per GitLab key. A renamed prefix renames no artifact.

## Remapping At The Boundary

A prefixed name exists to be read once. Each pipeline assigns every injected
variable it consumes to the bare name, at the boundary, and everything past
that boundary reads the bare name: jobs, scripts, Makefiles, tools.

```yaml
variables:
  ARTIFACT_REGISTRY: $GRP_KO_VAR_ARTIFACT_REGISTRY
  CI_IMAGES_REF: $GRP_KO_VAR_CI_IMAGES_REF
  CHE_PACKAGES_REF: $GRP_KO_VAR_CHE_PACKAGES_REF
  CI_IMAGE: $ARTIFACT_REGISTRY/ci-linux:$CI_IMAGES_REF
```

Such a value exists as two variables, and the distinction is what each one is
for:

- the **prefixed** one, defined in `infra/iac` and injected by GitLab. It is
  the value's home, and the only one anything writes.
- the **bare** one, defined in the pipeline as an assignment from the prefixed
  one. It is what the repo's code reads, and the name a tool expects (`glab`
  reads `GITLAB_TOKEN`, Terraform reads `TF_VAR_*`, che reads
  `CHE_PACKAGES_REF`).

One line per variable, and the scope that supplied the value is visible at
the point it enters. A script reading `$GRP_KO_VAR_...` directly is a defect:
the script then runs only under GitLab, and a local run cannot feed it from
`.env`.

Where the line goes depends on how far the bare name may reach:

- group variables the whole pipeline wants: the top-level `variables:` block.
- project secrets: the job that uses them, never top-level. A token reaches
  only the job that needs it.
- values that change a tool's behaviour under test: the jobs that want them.
  A suite asserting a tool's default must not inherit a variable overriding
  that default, or it proves the feature against itself.
  `GRP_KO_VAR_CHE_BACKUP_AUTO_CREATE` is group-scoped for exactly this
  reason: one place sets it, each repo decides which of its jobs sees it as
  `CHE_BACKUP_AUTO_CREATE`.

Never define the bare name in GitLab. Two GitLab-defined variables holding one
value drift the moment somebody edits the wrong one, and neither records which
is authoritative. The assignment is the whole point: it is derivation, in a
file under review, not a second source of truth.

## `.env.tpl`

Every repo whose pipeline remaps a variable tracks `.env.tpl` at its root
(the shared git ignore re-includes it under the `**/.*` rule). It is a
gomplate template che renders to `.env` (gitignored, `mergeUpsert`), the only
env template a repo has: no `templates/1-env/`, no `.env.example`, no second
seed file.
One line per bare name the pipeline derives, each fetching its value the way
the host can:

```sh
ARTIFACT_REGISTRY={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_ARTIFACT_REGISTRY" }}
CI_IMAGES_REF={{ shell "glab variable get -g konradodwrot GRP_KO_VAR_CI_IMAGES_REF" }}
GITLAB_TOKEN={{ secret "op://ProgrammaticAccess/gitlab/access_token" }}
MK_DRY_RUN=
```

It is the local counterpart of the remap block: what CI derives from GitLab, a
host renders into `.env` from the same source through `glab`, a secret through
`op`, a local-only knob as a plain or empty value. Under `mergeUpsert` a
`shell` or `secret` value overwrites the existing key on every render, a plain
value keeps it: pipe `| keepIfExisting` or `| alwaysUpdate` to say otherwise
per line. The two lists match, a variable added to one is added to the other
in the same change. Spec:
`repos/shared/spec/unvetted_ai/dev-env/env-template.story.md`.

## Naming

After the prefix, the name says what the value is, not who reads it:
`GRP_KO_VAR_ARTIFACT_REGISTRY`, not `GRP_KO_VAR_DOCKER_LOGIN_TARGET`. The bare
name is the prefixed name minus its prefix, unless a tool dictates another
spelling (`TF_VAR_github_token: $REPO_VAR_GITHUB_TOKEN`).

Values that are versions end in `_REF`, matching the pins already spelled that
way.

## What Is Not A CI Variable

A value that is neither secret nor environment-specific belongs in the file
that uses it, not in GitLab. A CI variable is for what cannot be committed (a
token) or what one place must own for everyone (a registry host, a pinned
version). Everything else is configuration, and configuration is reviewed in a
merge request.

Variables a trigger job passes downstream (`forward.yaml_variables`) are
pipeline-defined, not GitLab-defined: no prefix, no declaration in `infra/iac`.

## Example

Runnable version in `example/`: a `.gitlab-ci.yml` remapping every injected
variable at the boundary, the Terraform declaring them, the matching
`.env.tpl` template.

<!-- [<] 🤖🤖 -->
