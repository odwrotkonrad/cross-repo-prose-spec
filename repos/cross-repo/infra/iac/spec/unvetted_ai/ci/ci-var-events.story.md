# Feature: An apply reports the variables it moved

<!-- [>] 🤖🤖 -->

iac publishes every artifact version as a `GRP_KO_VAR_*` group variable. A
consumer rendering at a version the variable does not yet hold fails its own
docsgen check, so consumers must regenerate after the apply, never before.
Automation used to poll the variable for the new value and could not (the
variables API needs Owner). iac knows the moment itself: the plan it applied
lists every changed variable. The apply job reports them as one
`ci-var.changed` event through the shared `TriggerAutomation` template.

## As an infra operator

Merges to main, lets CI apply. Edits tfvars, never a consumer.

### Main apply sends the changed variables (todo)

I want the `apply` job to read the plan it is about to apply, list every
created or updated `gitlab_group_variable` as `{key, from, to}`, write the
list as `EVENT_DETAILS` in a dotenv report, and a `trigger-automation` job
that `needs: [apply]` to send it as `ci-var.changed`,
so that consumers regenerate at the value the variable now holds, with nothing
polling.

### Masked variables never leave the job (todo)

I want the list filtered by the resource's `masked` attribute, never by a key
list,
so that a token value never lands in a job log or an event, whatever it is
named.

### Nothing changed is still an event (todo)

I want an apply that moved no variable to send an empty list,
so that every main apply leaves a green dispatch trace downstream.

### A tfvars line is named like the variable it publishes (todo)

I want every tfvars key feeding `GRP_KO_VAR_<NAME>` named `<NAME>`
(`PROSE_ASSETS_REF`, `PROSE_SPEC_REF`, `MISC_REF`, `CI_IMAGES_REF`,
`CHE_PACKAGES_REF`, `CHE_BACKUP_AUTO_CREATE`, `ENABLE_DARWIN_CI`), the rename
a no-op plan,
so that the line automation bumps and the variable a consumer reads share one
name.

<!-- [<] 🤖🤖 -->
