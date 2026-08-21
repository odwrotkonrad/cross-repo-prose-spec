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

I want a tag pipeline to send `release.published` with `producer`,
`artifact` and `tag` in `details`,
so that automation learns of a release the same way from every producer.

### Details computed by a script still ride the template (todo)

I want `EVENT_TYPE` and `EVENT_DETAILS` written as a dotenv report by an
earlier job the trigger job `needs:`,
so that a sender whose payload is not known at YAML time (iac's changed
variables) uses the same template.

## As an automation maintainer

Reads events. Owns the handlers.

### An unknown type fails loudly (todo)

I want a `type` without a handler to fail the dispatch job with the type named,
so that a misspelled or unimplemented event is seen, never silently dropped.

<!-- [<] 🤖🤖 -->
