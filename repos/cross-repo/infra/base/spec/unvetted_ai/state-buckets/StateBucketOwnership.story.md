# Feature: The applier cannot grant itself its own bucket

<!-- [>] 🤖🤖 -->

Creating a state bucket and binding IAM on it needs project-IAM edit rights. An
applier service account cannot grant itself the role it needs to create the
bucket it will then write to. That is why an earlier attempt to own the
ci-variables bucket from the CI-applied root was added and reverted within
hours, and why `konradodwrot-ci-variables-tfstate` exists only because it was
made by hand.

Applied as admin, the problem disappears. `tf/tfstate-buckets/` creates each
CI-applied repo's bucket and grants that repo's applier SA
`roles/storage.objectAdmin` on that bucket alone. No applier ever holds
`storage.admin`, and the IAM-condition workaround fencing it to `-tfstate`
names is not needed.

One bucket cannot be created this way: base's own. A bucket cannot hold the
state that creates it, so `konradodwrot-base-tfstate` is made once by CLI with
the admin identity, out of band.

## As the infra operator

Owns the state buckets. Grants each applier its own.

### Give each CI repo a bucket it alone can write (todo)

I want one bucket per CI-applied repo, each granting only that repo's applier
SA `objectAdmin` on itself,
so that one repo's compromised applier cannot read or rewrite another repo's
state.

### Never hand an applier `storage.admin` (todo)

I want bucket creation and IAM binding to happen under the admin identity,
so that the role no applier should hold is held by no applier, and the IAM
condition fencing it to `-tfstate` names becomes unnecessary.

### Adopt the bucket that already exists (todo)

I want `konradodwrot-ci-variables-tfstate` imported rather than created,
so that adopting the hand-made bucket does not plan a replacement of live
state storage.

### Bootstrap base's own bucket outside terraform (todo)

I want `konradodwrot-base-tfstate` created once by CLI and documented as such,
so that the chicken-and-egg of a bucket holding its own creating state is
answered explicitly rather than rediscovered.

### Keep every bucket versioned and uniform (todo)

I want uniform bucket-level access and versioning on for every state bucket,
so that a bad apply is recoverable and per-object ACLs cannot reopen what the
IAM binding closes.

<!-- [<] 🤖🤖 -->
