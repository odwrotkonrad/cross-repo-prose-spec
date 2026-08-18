# Feature: Superseded pipelines stop paying for themselves

<!-- [>] 🤖🤖 -->

CI compute is billed by the minute on spot nodes. A pipeline whose commit was already
replaced produces a result nobody will read, while its jobs hold pods, occupy nodes the
autoscaler would otherwise release, and delay the pipeline superseding them. Cancelling
on the new commit is the whole saving.

Cancellation is opt-in per job, not blanket. A job with an external side effect must
finish or not start at all. Killing `terraform apply` halfway can leave a held state
lock that blocks every later pipeline until an operator force-unlocks it. Killing a
publish halfway can leave a half-pushed artifact. Those jobs stay uncancellable, and
pay for it.

## As a CI maintainer

Owns each repo's `.gitlab-ci.yml`. Declares which jobs may be killed.

### Superseded pipelines stop burning minutes at once (todo)

I want a new commit on a branch to cancel the running pipeline's cancellable
jobs immediately,
so that their pods release nodes instead of producing a result for a commit
nobody will merge.

### Cancellability declared once per repo (todo)

I want interruptibility set in the existing `default:` block beside shared tags
and retry rules,
so that every job inherits it and an exception is an explicit visible override.

### Both halves are required (todo)

I want the project setting and job-level interruptible declared together,
so that nobody enables the setting alone and gets zero saving because GitLab
cancels only jobs marked cancellable.

### Terraform is never killed holding the state lock (todo)

I want terraform jobs exempt from cancellation and run to completion,
so that no later pipeline blocks on a lock left held with no owner, waiting for
a hand force-unlock.

### A release is never left half-published (todo)

I want release, tag and registry-publish jobs to finish rather than cancel,
so that no partially pushed image, tag or package is left behind.

### Exemptions are stated, not discovered (todo)

I want the uncancellable set to cover only jobs with an external side effect,
each saying so at the job,
so that a reader sees why a job is exempt without inferring it, tests, lint,
validate and build staying cancellable where the saving is.

### An exempt job still stops before it starts (todo)

I want protection to apply to work in progress, not work not yet begun,
so that an exempt job in an already-superseded pipeline may be skipped before
it acquires a lock or pushes anything.

### Cancellation does not consume the retry budget (todo)

I want a cancelled job treated as cancelled, not failed,
so that it is not retried and the retry budget stays reserved for genuine
infrastructure faults.

## As an infra operator

Applies the terraform module that creates every project. Does not touch repos
one by one.

### The setting is applied in one place (todo)

I want auto-cancel applied by the single project module,
so that every project carries it without declaring it and a new repo inherits
it on creation.

### Peak node count falls without lowering a cap (todo)

I want cancellation in force during rapid pushes, when the pools are scaled
furthest up,
so that freed pods let the autoscaler shed nodes within its short idle window.

<!-- [<] 🤖🤖 -->
