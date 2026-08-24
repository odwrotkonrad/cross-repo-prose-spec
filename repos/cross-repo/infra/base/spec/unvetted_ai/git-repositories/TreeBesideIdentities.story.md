# Feature: The GitLab tree sits with the identities scoped into it

<!-- [>] 🤖🤖 -->

A group or a project is what an identity's reach is expressed against: a group
access token reaches a subtree, a project token reaches one project. A root
able to create those containers can widen an identity's reach by creating a new
one inside its scope, without touching a single IAM resource. So the tree is
owned by the root no pipeline can apply, next to the identities themselves.

The same argument covers 1Password vaults, which today are only read as data
sources and are assumed to already exist. They become real resources here.

Retiring a repo means emptying and archiving it. A `gitlab_project` destroy is
never the answer, whatever a plan suggests.

## As the infra operator

Owns the group tree, the projects and their protections.

### Keep the tree with the identities (todo)

I want groups, projects, protections and mirrors declared in the same root as
the tokens scoped to them,
so that no CI-applied root can create a container that widens its own token's
reach.

### Create the vaults instead of assuming them (todo)

I want the 1Password vaults declared as resources rather than read as data
sources,
so that the containers secrets live in are described by the same root that
creates the secrets.

### Never destroy a repo (todo)

I want retirement to mean emptied and archived, and any plan containing a
`gitlab_project` destroy treated as a defect,
so that no split, move or cleanup can delete a repository.

### Move a project shell before its contents (todo)

I want billing-attached and `prevent_destroy` projects imported ahead of
anything declared inside them,
so that a child resource imports against a container the new root already
owns.

<!-- [<] 🤖🤖 -->
