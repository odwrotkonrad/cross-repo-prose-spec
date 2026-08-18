# Feature: IAM provisioning

<!--[>] 🤖🤖 -->

## As a security owner

Reads and changes sandbox permissions. Does not operate the sandbox.

### Every sandbox permission is readable in one place (todo)

I want the service account, gitlab token and both ssh keys declared in the iac
repo's designated module,
so that the sandbox's reach is answered by one file.

### A permission changes only through the module (todo)

I want a change taking effect by editing and applying that module, with no grant
made outside it,
so that the module is the truth and not a description.

### The sandbox cannot widen its own access (todo)

I want a session's attempt to grant itself a permission or issue a credential
refused,
so that privilege escalation is not a session capability.

<!--[<] 🤖🤖 -->
