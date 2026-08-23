# Feature: IAM provisioning

<!--[>] 🤖🤖 -->

## As a security owner

Reads and changes sandbox permissions. Does not operate the sandbox.

### Every sandbox permission is readable in one place (implemented)

I want the service account, gitlab token and both ssh keys declared in the iac
repo's designated module,
so that one file answers what the sandbox can reach.

### A permission changes only through the module (implemented)

I want a change taking effect by editing and applying that module, no grant
made outside it,
so that the module is the truth, not a description.

### The sandbox cannot widen its own access (implemented)

I want a session's attempt to grant itself a permission or issue a credential
refused,
so that a session cannot escalate privilege.

<!--[<] 🤖🤖 -->
