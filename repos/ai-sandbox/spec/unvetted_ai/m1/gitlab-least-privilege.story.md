# Feature: GitLab least privilege

<!--[>] 🤖🤖 -->

## As an AI agent

Pushes work for review. Does not decide what lands on main.

### Work in progress ships to a branch and an MR (todo)

I want a push to an unprotected branch and an opened merge request both
succeeding,
so that a session's output arrives where a human reads it.

## As a security owner

Bounds the token. Does not push code.

### Review stays a human act (todo)

I want a merge attempt with the sandbox token refused,
so that nothing reaches main unreviewed.

### Protected branches are unwritable (todo)

I want a direct push to a protected branch refused,
so that branch protection holds against the sandbox too.

### The token cannot leave its group (todo)

I want reads and writes on a project outside the sandbox group refused,
so that the blast radius ends at the group.

### Nothing can be destroyed (todo)

I want deleting a branch, repository or group refused,
so that write access is not delete access.

<!--[<] 🤖🤖 -->
