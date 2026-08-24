# Feature: Every registry lives beside the identities that read it

<!-- [>] 🤖🤖 -->

The four artifact registries (`ci` and the three `remote-*` pull-through
caches) sat in the cluster module, though a registry depends on nothing but a
project and a region. What tied them there was their IAM: the node, job and
runner service accounts that read and write them. Those identities move here,
so the registries move with them.

A fifth is new: a generic-format repository holding this repo's own release
artifact.

The `ci` repository's `expire-buildx-cache` cleanup policy is dropped in the
move. No registry carries automatic cleanup.

## As the infra operator

Owns the registries and the grants onto them.

### Move every registry, not some (todo)

I want `ci`, `remote-gitlab`, `remote-dockerhub` and `remote-go` all imported
here,
so that no registry is left behind in a root that no longer holds the
identities allowed to read it.

### Keep the registry IAM with the identities (todo)

I want the node, job and runner grants to move together with the registries and
the service accounts they name,
so that neither half of a binding outlives the other in a different state.

### Carry the applier grant the registries wait on (todo)

I want `google_project_iam_member.ci_applier`, which every registry names in
`depends_on` so the applier holds `artifactregistry.admin` before one is
created, moved as part of the same step,
so that the ordering the registries rely on survives the move rather than being
discovered missing on the first apply in the new root.

### Drop automatic cleanup (todo)

I want the `expire-buildx-cache` policy on the `ci` repository removed and no
cleanup policy added to any other,
so that nothing deletes an artifact on a schedule nobody is watching.

### Publish the registry hostnames as group variables (todo)

I want the four `GRP_KO_VAR_ARTIFACT_REGISTRY*` variables published from the
registry outputs here,
so that the value and the variable carrying it are owned by one root.

### Hold this repo's own release in a generic repository (todo)

I want a generic-format repository created for the `base-outputs` package,
so that the outputs artifact has a home that is not a container registry
pretending to hold a tarball.

<!-- [<] 🤖🤖 -->
