<!--[>] 🤖🤖 -->
Feature: Superseded pipelines stop paying for themselves

CI compute is billed by the minute on spot nodes. A pipeline whose commit has already
been replaced is producing a result nobody will read: its jobs still hold pods, still
occupy nodes the autoscaler would otherwise release, and still delay the pipeline that
supersedes them. Cancelling on the new commit is the whole saving.

Cancellation is opt-in per job, not blanket. A job with an external side effect must
finish or not start at all: killing `terraform apply` halfway can leave a held state
lock that blocks every later pipeline until an operator force-unlocks it, and killing a
publish halfway can leave a half-pushed artifact. Those jobs stay uncancellable, and
pay for it.

## Cancelling

Scenario: a superseded pipeline stops burning CI minutes at once
  Status: todo
  Given a merge request with a pipeline still running
  When a new commit is pushed to its branch and a new pipeline starts
  Then the running pipeline's cancellable jobs are cancelled immediately
  And their pods release the nodes they held
  And no job keeps running to produce a result for a commit nobody will merge

Scenario: cancelling is switched on in one place, not per repo
  Status: todo
  Given every project in the workspace is created by one terraform module
  When the auto-cancel setting is applied
  Then every project carries it without declaring it itself
  And a new repo inherits the behavior on creation

Scenario: the setting alone cancels nothing
  Status: todo
  Given GitLab cancels only jobs a pipeline marks cancellable
  When the project setting is enabled but no job declares itself interruptible
  Then nothing is cancelled and the saving is zero
  And both halves are required, which is why they are specified together

Scenario: a job declares its own cancellability once, near its tags
  Status: todo
  Given each repo's pipeline already carries a `default:` block holding shared tags and retry rules
  When cancellability is declared there
  Then every job inherits it without repeating the declaration
  And a job needing the opposite overrides it explicitly, so the exception is visible

## Not cancelling

Scenario: terraform is never killed holding the state lock
  Status: todo
  Given terraform takes a lock on remote state for the length of a plan or an apply
  And a process killed mid-run can leave that lock held with no owner
  When a new commit supersedes a pipeline running a terraform job
  Then that job is not cancelled and runs to completion
  And no later pipeline is blocked waiting on a lock an operator must clear by hand

Scenario: a release is not left half-published
  Status: todo
  Given release, tag and registry-publish jobs push artifacts the outside world then sees
  When a new commit arrives while one is running
  Then it finishes rather than being cancelled
  And no partially pushed image, tag or package is left behind

Scenario: the exceptions are few and stated, not discovered
  Status: todo
  Given most jobs are tests, lint, validate and build, which are safe to cancel and where the saving is
  When the uncancellable set is chosen
  Then it covers only jobs with an external side effect
  And each one says so at the job, so a reader knows why it is exempt without inferring it

Scenario: an exempt job still stops when the whole pipeline is redundant
  Status: todo
  Given an exempt job is protected from cancellation, not from the queue
  When it has not yet started and its pipeline is already superseded
  Then it may be skipped before it acquires any lock or pushes anything
  And protection applies to work in progress, not to work not yet begun

## Cost

Scenario: the saving is largest exactly when the cluster is busiest
  Status: todo
  Given rapid pushes to a branch under active work produce the most superseded pipelines
  And that is also when the node pools are scaled furthest up
  When cancellation is in force
  Then freed pods let the autoscaler shed nodes within its short idle window
  And peak node count falls without any cap being lowered

Scenario: cancellation does not fight the retry policy
  Status: todo
  Given pipelines retry jobs that fail from runner or infrastructure faults
  And a cancelled job is not a failed one
  When a job is cancelled because its commit was superseded
  Then it is not retried
  And the retry budget stays reserved for genuine infrastructure faults

<!--[<] 🤖🤖 -->
