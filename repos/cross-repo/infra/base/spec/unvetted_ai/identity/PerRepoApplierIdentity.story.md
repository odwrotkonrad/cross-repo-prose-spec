# Feature: One applier identity per repo

<!-- [>] 🤖🤖 -->

One terraform root holding four concerns needed one identity holding every
permission any of them needed. `tf-restricted-infra` could edit the GitLab
tree, the GKE cluster, the org policy and every secret, because one of its four
concerns needed each.

Split by concern, each root gets its own applier service account carrying only
its own reach. All of them are declared here, in the admin-applied root,
because an applier cannot grant itself its permissions.

Workload identity bindings live here too, away from the cluster that once
supplied their pool name. The pool is always `<project_id>.svc.id.goog`, so the
member string is built from the project id and the known namespace and service
account names. `ci-cluster` consumes the resulting emails for the cluster-side
half.

## As the infra operator

Declares every machine identity. Grants each its own reach.

### Give each CI-applied repo its own applier (todo)

I want one applier service account per CI-applied repo, replacing the single
shared one,
so that a repo's applier reaches only what that repo declares.

### Grant permissions from the identity that can (todo)

I want every applier's role grants declared in the admin-applied root,
so that the grant is made by an identity holding the rights to make it, which
no applier does for itself.

### Keep the publisher out of the applier set (todo)

I want `base-publisher` declared as its own service account, holding
`objectViewer` on the base bucket and nothing else,
so that the identity CI holds for this repo cannot be mistaken for one that
applies.

### Bind workload identity without the cluster (todo)

I want the workload identity member string built from the project id and known
namespace and service account names,
so that identities live in this root while the cluster lives in another, with
no dependency between them and no cycle.

### Retire the shared applier last (todo)

I want `tf-restricted-infra` kept until the final CI-applied repo holds its own
applier,
so that no repo is left mid-migration without an identity that can apply it.

### Trim each applier's roles to its own concern (todo)

I want the shared root's role grants re-pointed per repo and cut to what that
repo needs, rather than copied wholesale,
so that the split delivers least privilege rather than three copies of one
over-broad identity.

### Derive each custom role from the resources it manages (todo)

I want each identity's permission list derived from the resource families its
own terraform declares, rather than copied from the predefined role and cut by
eye,
so that the list is reproducible from the config: across the nine roles
`tf-restricted-infra` holds on the ci project, that is 171 permissions of 1762,
before dropping the verbs the config never uses.

### Prove every permission exists before applying a role (todo)

I want each custom role's permissions checked against
`gcloud iam list-testable-permissions`, rejecting any that is missing or not
`SUPPORTED` in custom roles,
so that a typo or a permission GCP does not allow in a custom role fails at my
desk rather than at apply, which is a separate failure from the list being
incomplete.

### Verify a role a plan cannot exercise (todo)

I want the node identity's puller role verified by watching a pod actually pull
after a node pool drain, not by a green plan,
so that the one role whose consumer is containerd rather than terraform is
proven by the thing that uses it.

### Stop paying for MR plans with an unprotected write credential (todo)

I want each repo's MR plan job to authenticate as that repo's read-only
unprotected applier, and only its protected twin to hold write,
so that `REPO_VAR_GOOGLE_CREDENTIALS` on iac, unprotected today because a
protected variable expands empty on an MR branch and the plan job needs
credentials, stops being a full-apply key readable from every MR branch.

<!-- [<] 🤖🤖 -->
