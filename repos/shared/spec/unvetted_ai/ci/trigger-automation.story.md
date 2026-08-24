# Feature: One Way To Talk To Automation

<!-- [>] 🤖🤖 -->

Five producers each carried a hand-shaped trigger job forwarding three
variables (`PRODUCER`, `RELEASE_TAG`, `PRODUCER_ARTIFACT`) to
`cross-repo/automation`. A sixth sender with a different message would have
meant a sixth shape and a sixth reader. One shared GitLab CI template,
`TriggerAutomation` in `cross-repo/misc`, carries one JSON event instead:
`type` names the handler, `details` is the sender's payload, `source` is
filled by the template from predefined variables.

## As a repo maintainer

Sends automation an event from CI. Knows the event, not automation's pipeline.

### I send one event through one template (todo)

I want a job that `extends: .TriggerAutomation`, included from
`cross-repo/misc` at `MISC_REF`, setting only `stage`, `rules`, `EVENT_TYPE`
and `EVENT_DETAILS`,
so that every sender looks the same and a new event is a new `type`, not a new
job shape.

### The event names its source without my help (todo)

I want `source.project`, `source.pipeline`, `source.ref` and `source.sha`
filled by the template from the sending job's predefined variables,
so that a sender cannot misreport where an event came from.

### A release is one event (todo)

I want a tag pipeline to send `release.published` with `producer` and
`artifact` in `details`, the tag read from `source.ref`,
so that automation learns of a release the same way from every producer, and
no sender restates what the template already knows (a variable nested in
`details` expands downstream, where the tag is gone).

### Details computed by a script still ride the template (todo)

I want `EVENT_TYPE` and `EVENT_DETAILS` written as a dotenv report by an
earlier job the trigger job `needs:`,
so that a sender whose payload is not known at YAML time (iac's changed
variables) uses the same template.

## As an infra operator

Owns the identity every sender posts with.

### One identity posts every event, published once (todo)

I want the `ko-automation` group access token published as a protected group
variable rather than a pipeline trigger token created per emitting project,
so that every repo in the group posts as one identity that is declared once,
instead of each repo holding a separate credential that nothing tells apart.

### The sender posts as a user, not a trigger (todo)

I want `emit-events.zsh` to call `POST /projects/:id/pipeline` with a
`PRIVATE-TOKEN` header,
so that the call matches the credential: `POST /trigger/pipeline` with a
`token=` form field accepts only a per-project trigger token, which is the
identity shape being replaced.

### Only protected refs may emit (todo)

I want the variable carrying that token to be protected, given that events are
emitted only from tag and default-branch pipelines,
so that an MR pipeline on an unreviewed branch cannot fan regen MRs across the
group.

### A missing credential fails the release, visibly (todo)

I want an unset token to fail the emitting job rather than pass by emitting
nothing, given that a 404 from the API reads as "no such project" and hides an
empty credential,
so that a release whose announcement never landed is not mistaken for a
successful one.

## As an automation maintainer

Reads events. Owns the handlers.

### An unknown type fails loudly (todo)

I want a `type` without a handler to fail the dispatch job naming the type,
so that a misspelled or unimplemented event is seen, never silently dropped.

<!-- [<] 🤖🤖 -->
