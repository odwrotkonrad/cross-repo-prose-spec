# Feature: GitLab least privilege

<!--[>] 🤖🤖 -->

## As an AI agent

Pushes work for review. Does not decide what lands on main.

### Work in progress ships to a branch and an MR (implemented)

I want a push to an unprotected branch and an opened merge request both
succeeding,
so that a session's output arrives where a human reads it.

## As a security owner

Bounds the token. Does not push code.

### Review stays a human act (implemented)

I want a merge attempt with the sandbox token refused,
so that nothing reaches main unreviewed.

### Protected branches are unwritable (implemented)

I want a direct push to a protected branch refused,
so that branch protection holds against the sandbox too.

### The token cannot leave its group (implemented)

I want reads and writes on a project outside the sandbox group refused,
so that the blast radius ends at the group.

### Nothing can be destroyed (implemented)

I want deleting a repository or group refused,
so that write access is not delete access.

### A pushed branch cannot be unpushed (todo)

I want deleting an unprotected branch refused,
so that no history leaves through the token.

<!--[<] 🤖🤖 -->
